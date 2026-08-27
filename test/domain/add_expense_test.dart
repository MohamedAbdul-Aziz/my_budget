import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/expenses/domain/usecases/add_expense.dart';
import 'package:my_budget/features/expenses/presentation/cubit/expense_form_cubit.dart';

void main() {
  group('AddExpense.validate', () {
    test('rejects zero and negative amounts', () {
      expect(
        AddExpense.validate(amount: 0, categoryId: 'cat_food'),
        isA<ValidationFailure>(),
      );
      expect(
        AddExpense.validate(amount: -5, categoryId: 'cat_food'),
        isA<ValidationFailure>(),
      );
    });

    test('rejects a missing category', () {
      expect(
        AddExpense.validate(amount: 10, categoryId: ''),
        isA<ValidationFailure>(),
      );
    });

    test('accepts a normal expense', () {
      expect(AddExpense.validate(amount: 12.5, categoryId: 'cat_food'), isNull);
    });
  });

  group('ExpenseFormCubit.parseAmount', () {
    test('accepts both decimal separators', () {
      expect(ExpenseFormCubit.parseAmount('12.50'), 12.5);
      expect(ExpenseFormCubit.parseAmount('12,50'), 12.5);
    });

    test('rounds to cents', () {
      expect(ExpenseFormCubit.parseAmount('1.239'), 1.24);
      expect(ExpenseFormCubit.parseAmount('12.999'), 13.0);
    });

    test('rejects text that is not an amount', () {
      expect(ExpenseFormCubit.parseAmount(''), isNull);
      expect(ExpenseFormCubit.parseAmount('  '), isNull);
      expect(ExpenseFormCubit.parseAmount('abc'), isNull);
    });
  });
}
