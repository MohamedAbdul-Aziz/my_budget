import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../expenses/domain/usecases/add_expense.dart';
import '../entities/recurrence_frequency.dart';
import '../entities/recurring_draft.dart';
import '../entities/recurring_expense.dart';
import '../repositories/recurring_repository.dart';

/// Validates, then creates a recurring payment or updates [existing].
class SaveRecurringExpense {
  const SaveRecurringExpense(this._repository);

  final RecurringRepository _repository;

  /// A new payment counts from [today]: nothing from before it was set up
  /// is ever reported overdue.
  Future<ApiResult<RecurringExpense>> call(
    RecurringDraft draft, {
    RecurringExpense? existing,
    required DateTime today,
  }) async {
    final failure = validate(draft);
    if (failure != null) return ResultFailure(failure);

    final title = draft.title.trim();
    final category = draft.category!;
    final dueMonth = draft.frequency == RecurrenceFrequency.yearly
        ? draft.dueMonth
        : null;

    if (existing == null) {
      return _repository.createRecurring(
        title: title,
        amount: draft.amount,
        categoryId: category.id,
        frequency: draft.frequency,
        dueDay: draft.dueDay,
        dueMonth: dueMonth,
        mode: draft.mode,
        startsOn: RecurringExpense.dayOf(today),
      );
    }

    final updated = existing.copyWith(
      title: title,
      amount: draft.amount,
      category: category,
      frequency: draft.frequency,
      dueDay: draft.dueDay,
      dueMonth: () => dueMonth,
      mode: draft.mode,
    );
    return _repository.updateRecurring(
      updated.copyWith(
        paidThrough: () => carriedPaidThrough(existing, updated, today: today),
      ),
    );
  }

  static Failure? validate(RecurringDraft draft) {
    final title = draft.title.trim();
    if (title.isEmpty) {
      return const ValidationFailure(FailureCode.titleRequired);
    }
    if (title.length > RecurringExpense.maxTitleLength) {
      return const ValidationFailure(FailureCode.titleTooLong);
    }

    final category = draft.category;
    // Recurring payments are spending; income has no bills to confirm.
    if (category == null || category.isIncome) {
      return const ValidationFailure(FailureCode.categoryRequired);
    }
    final amountFailure = AddExpense.validate(
      amount: draft.amount,
      categoryId: category.id,
    );
    if (amountFailure != null) return amountFailure;

    final day = draft.dueDay;
    final valid = switch (draft.frequency) {
      RecurrenceFrequency.weekly => day >= 1 && day <= 7,
      RecurrenceFrequency.monthly => day >= 1 && day <= 31,
      RecurrenceFrequency.yearly => switch (draft.dueMonth) {
        final month? when month >= 1 && month <= 12 =>
          day >= 1 && day <= RecurringExpense.longestMonth(month),
        _ => false,
      },
    };
    return valid ? null : const ValidationFailure(FailureCode.dueDayInvalid);
  }

  /// What a changed schedule keeps of what was already paid.
  ///
  /// Moving a payment within the same frequency keeps its period paid:
  /// moving the rent from the 1st to the 5th does not ask for this month's
  /// rent again. Changing how often it repeats settles everything before
  /// [today] instead, so nothing turns overdue just because the schedule
  /// changed.
  static DateTime? carriedPaidThrough(
    RecurringExpense before,
    RecurringExpense after, {
    required DateTime today,
  }) {
    final paid = before.paidThrough;
    if (before.frequency == after.frequency) {
      return paid == null ? null : after.dueInCycleOf(paid);
    }
    final day = RecurringExpense.dayOf(today);
    final yesterday = DateTime(day.year, day.month, day.day - 1);
    return paid != null && paid.isAfter(yesterday) ? paid : yesterday;
  }
}
