import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/update_expense.dart';
import 'expense_form_state.dart';

/// One instance per add/edit screen — registered as a factory in the locator.
class ExpenseFormCubit extends Cubit<ExpenseFormState> {
  ExpenseFormCubit({
    required AddExpense addExpense,
    required UpdateExpense updateExpense,
  }) : _addExpense = addExpense,
       _updateExpense = updateExpense,
       super(ExpenseFormState.initial());

  final AddExpense _addExpense;
  final UpdateExpense _updateExpense;

  /// Seeds the form. [existing] switches it to edit mode; otherwise the date
  /// defaults to today and [suggestedCategory] preselects a category so a new
  /// expense can be saved with nothing but an amount.
  void start({Expense? existing, ExpenseCategory? suggestedCategory}) {
    emit(
      ExpenseFormState(
        expenseId: existing?.id,
        category: existing?.category ?? suggestedCategory,
        date: existing?.date ?? DateTime.now(),
      ),
    );
  }

  void selectCategory(ExpenseCategory category) =>
      emit(state.copyWith(category: category, status: ExpenseFormStatus.editing));

  void selectDate(DateTime date) => emit(state.copyWith(date: date));

  Future<void> submit({required String amountText, String? description}) async {
    final category = state.category;
    if (category == null) {
      emit(
        state.copyWith(
          status: ExpenseFormStatus.failure,
          error: FailureCode.categoryRequired,
        ),
      );
      return;
    }

    final amount = parseAmount(amountText);
    if (amount == null) {
      emit(
        state.copyWith(
          status: ExpenseFormStatus.failure,
          error: FailureCode.amountInvalid,
        ),
      );
      return;
    }

    emit(state.copyWith(status: ExpenseFormStatus.submitting));

    final id = state.expenseId;
    final result = id == null
        ? await _addExpense(
            amount: amount,
            categoryId: category.id,
            date: state.date,
            description: description,
          )
        : await _updateExpense(
            id: id,
            amount: amount,
            categoryId: category.id,
            date: state.date,
            description: description,
          );

    switch (result) {
      case Success():
        emit(state.copyWith(status: ExpenseFormStatus.success));
      case ResultFailure(:final failure):
        emit(
          state.copyWith(
            status: ExpenseFormStatus.failure,
            error: failure.code,
          ),
        );
    }
  }

  /// Accepts both `1,50` and `1.50` so the numeric keypad works in every
  /// locale. Returns null when the text is not a usable amount.
  static double? parseAmount(String text) {
    final cleaned = text.trim().replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null || value.isNaN || value.isInfinite) return null;
    return double.parse(value.toStringAsFixed(2));
  }
}
