import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../domain/entities/recurrence_frequency.dart';
import '../../domain/entities/recurring_draft.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/entities/recurring_mode.dart';
import '../../domain/usecases/save_recurring_expense.dart';
import 'recurring_form_state.dart';

/// One instance per add/edit screen — registered as a factory in the locator.
class RecurringFormCubit extends Cubit<RecurringFormState> {
  RecurringFormCubit({
    required SaveRecurringExpense saveRecurring,
    DateTime Function()? clock,
  }) : _saveRecurring = saveRecurring,
       _clock = clock ?? DateTime.now,
       super(const RecurringFormState());

  final SaveRecurringExpense _saveRecurring;
  final DateTime Function() _clock;

  /// The day last picked for each frequency, so trying weekly and going
  /// back to monthly keeps the day of the month.
  final Map<RecurrenceFrequency, int> _days = {};

  /// Seeds the form. [existing] switches it to edit mode. A new payment is
  /// an expense, monthly, due on today's date, and asks before logging
  /// anything.
  void start({RecurringExpense? existing, ExpenseCategory? suggestedCategory}) {
    final today = _clock();
    _days
      ..clear()
      ..[RecurrenceFrequency.weekly] = today.weekday
      ..[RecurrenceFrequency.monthly] = today.day
      ..[RecurrenceFrequency.yearly] = today.day;
    if (existing != null) _days[existing.frequency] = existing.dueDay;

    emit(
      RecurringFormState(
        existing: existing,
        type:
            existing?.category.type ??
            suggestedCategory?.type ??
            TransactionType.expense,
        category: existing?.category ?? suggestedCategory,
        frequency: existing?.frequency ?? RecurrenceFrequency.monthly,
        dueDay: existing?.dueDay ?? today.day,
        dueMonth: existing?.dueMonth ?? today.month,
        mode: existing?.mode ?? RecurringMode.reminder,
      ),
    );
  }

  void selectCategory(ExpenseCategory category) =>
      emit(state.copyWith(type: category.type, category: category));

  /// Switches between a payment and income, starting on [category], the
  /// first of that type, since the current one no longer fits.
  void selectType(TransactionType type, {ExpenseCategory? category}) {
    if (type == state.type) return;
    emit(
      RecurringFormState(
        existing: state.existing,
        type: type,
        category: category,
        frequency: state.frequency,
        dueDay: state.dueDay,
        dueMonth: state.dueMonth,
        mode: state.mode,
      ),
    );
  }

  void selectFrequency(RecurrenceFrequency frequency) {
    if (frequency == state.frequency) return;
    _days[state.frequency] = state.dueDay;
    final day = _days[frequency] ?? 1;
    emit(
      state.copyWith(
        frequency: frequency,
        dueDay: frequency == RecurrenceFrequency.yearly
            ? _fitMonth(day, state.dueMonth)
            : day,
      ),
    );
  }

  void selectDueDay(int day) => emit(state.copyWith(dueDay: day));

  /// A day the new month does not have moves to its last day.
  void selectDueMonth(int month) => emit(
    state.copyWith(dueMonth: month, dueDay: _fitMonth(state.dueDay, month)),
  );

  void selectMode(RecurringMode mode) => emit(state.copyWith(mode: mode));

  Future<void> submit({
    required String title,
    required String amountText,
  }) async {
    if (state.isSubmitting) return;
    // Back to editing first, so the same failure twice in a row is still two
    // changes of status, and the page says why both times.
    emit(state.copyWith());
    final amount = AmountInput.parse(amountText);
    if (amount == null) {
      emit(
        state.copyWith(
          status: RecurringFormStatus.failure,
          error: FailureCode.amountInvalid,
        ),
      );
      return;
    }

    emit(state.copyWith(status: RecurringFormStatus.submitting));
    final result = await _saveRecurring(
      RecurringDraft(
        title: title,
        amount: amount,
        category: state.category,
        frequency: state.frequency,
        dueDay: state.dueDay,
        dueMonth: state.dueMonth,
        mode: state.mode,
      ),
      existing: state.existing,
      today: _clock(),
    );
    emit(switch (result) {
      Success() => state.copyWith(status: RecurringFormStatus.success),
      ResultFailure(:final failure) => state.copyWith(
        status: RecurringFormStatus.failure,
        error: failure.code,
      ),
    });
  }

  static int _fitMonth(int day, int month) {
    final longest = RecurringExpense.longestMonth(month);
    return day > longest ? longest : day;
  }
}
