import '../../../../core/error/api_result.dart';
import '../entities/assistant_message.dart';
import '../entities/spending_summary.dart';

abstract interface class AssistantRepository {
  /// Sends [question] with the [summary] and the last few [history] messages
  /// to the assistant's server, and answers with its reply. Needs a signed-in
  /// account: the server counts each account's questions per day.
  Future<ApiResult<String>> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
  });

  /// Whether the user agreed, on this phone, to send their summary out.
  Future<ApiResult<bool>> hasConsent();

  Future<ApiResult<void>> setConsent({required bool granted});
}
