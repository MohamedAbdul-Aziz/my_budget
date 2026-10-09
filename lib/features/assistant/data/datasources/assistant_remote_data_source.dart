import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/entities/spending_summary.dart';

abstract interface class AssistantRemoteDataSource {
  Future<String> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
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
  Future<String> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
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
      return answer;
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
      (401, _) => AuthFailure(FailureCode.signInRequired, '$error'),
      (429, 'daily_limit') => AssistantFailure(
        FailureCode.aiDailyLimit,
        '$error',
      ),
      (429, _) => AssistantFailure(FailureCode.aiBusy, '$error'),
      _ => AssistantFailure(FailureCode.aiUnavailable, '$error'),
    };
  }
}
