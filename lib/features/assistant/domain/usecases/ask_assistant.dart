import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../entities/assistant_message.dart';
import '../entities/spending_summary.dart';
import '../repositories/assistant_repository.dart';
import 'build_spending_summary.dart';

/// Asks the assistant one question. A fresh summary is built for every
/// question, so the answer always reflects the data as it is now.
class AskAssistant {
  const AskAssistant({
    required AssistantRepository repository,
    required BuildSpendingSummary buildSummary,
  }) : _repository = repository,
       _buildSummary = buildSummary;

  static const int maxQuestionLength = 500;

  /// Earlier messages sent along for context; the server accepts no more.
  static const int maxHistory = 6;

  final AssistantRepository _repository;
  final BuildSpendingSummary _buildSummary;

  static FailureCode? validate(String question) {
    final text = question.trim();
    if (text.isEmpty) return FailureCode.questionRequired;
    if (text.length > maxQuestionLength) return FailureCode.questionTooLong;
    return null;
  }

  Future<ApiResult<String>> call({
    required String question,
    required List<AssistantMessage> history,
    required String Function(ExpenseCategory) labelOf,
    required String currency,
    required String languageCode,
    DateTime? now,
  }) async {
    if (validate(question) case final code?) {
      return ResultFailure(ValidationFailure(code));
    }

    final SpendingSummary summary;
    switch (await _buildSummary(
      labelOf: labelOf,
      currency: currency,
      now: now,
    )) {
      case Success(:final data):
        summary = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    final recent = history.length <= maxHistory
        ? history
        : history.sublist(history.length - maxHistory);
    return _repository.ask(
      question: question.trim(),
      summary: summary,
      history: recent,
      languageCode: languageCode,
    );
  }
}
