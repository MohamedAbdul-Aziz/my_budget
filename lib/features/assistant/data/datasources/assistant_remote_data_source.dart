import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/entities/assistant_reply.dart';
import '../../domain/entities/spending_summary.dart';

abstract interface class AssistantRemoteDataSource {
  /// [deviceId] counts a guest's questions; the server ignores it for a
  /// signed-in user, who is counted by account.
  Future<AssistantReply> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
    required String deviceId,
  });
}

/// Talks to the `ai-assistant` Edge Function. The AI provider's key lives
/// only on the server; the app never sees it.
class AssistantRemoteDataSourceImpl implements AssistantRemoteDataSource {
  const AssistantRemoteDataSourceImpl(this._functions);

  static const String functionName = 'ai-assistant';

  /// Longer than the server's own wait for the provider, so the server's
  /// answer (even an error) normally arrives first.
  static const Duration timeout = Duration(seconds: 45);

  final FunctionsClient _functions;

  @override
  Future<AssistantReply> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
    required String deviceId,
  }) async {
    final FunctionResponse response;
    try {
      response = await _functions
          .invoke(
            functionName,
            body: {
              'question': question,
              'summary': summary.toJson(),
              'history': [for (final message in history) message.toJson()],
              'language': languageCode,
              'deviceId': deviceId,
            },
          )
          .timeout(timeout);
    } on FunctionsFetchException catch (error) {
      // No response reached the phone: the request never got through.
      throw NetworkFailure('$error');
    } on FunctionException catch (error) {
      throw failureOf(error);
    } on SocketException catch (error) {
      throw NetworkFailure('$error');
    } on http.ClientException catch (error) {
      throw NetworkFailure('$error');
    } on TimeoutException catch (error) {
      throw NetworkFailure('$error');
    }

    final data = response.data;
    if (data case {'answer': final String answer} when answer.isNotEmpty) {
      // Older servers sent no suggestions; anything odd is just left out.
      final followUps = switch (data['followUps']) {
        final List<Object?> list => [
          for (final item in list)
            if (item is String && item.trim().isNotEmpty) item.trim(),
        ],
        _ => const <String>[],
      };
      return AssistantReply(answer: answer, followUps: followUps);
    }
    throw const AssistantFailure(FailureCode.aiUnavailable, 'no answer');
  }

  /// Reads the server's `{error: …}` codes; see
  /// `supabase/functions/ai-assistant/index.ts`.
  static Failure failureOf(FunctionException error) {
    final code = switch (error.details) {
      {'error': final String code} => code,
      _ => null,
    };
    return switch ((error.status, code)) {
      (429, 'daily_limit') => AssistantFailure(
        FailureCode.aiDailyLimit,
        '$error',
      ),
      (429, _) => AssistantFailure(FailureCode.aiBusy, '$error'),
      _ => AssistantFailure(FailureCode.aiUnavailable, '$error'),
    };
  }
}
