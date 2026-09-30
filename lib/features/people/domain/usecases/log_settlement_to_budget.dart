import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../entities/settlement.dart';
import '../repositories/people_repository.dart';
import 'add_person_transaction.dart';

/// Records a settlement in the monthly budget: money paid to settle is an
/// expense in Other, money received is income in Other income. The user can
/// move it to another category afterwards like any other transaction.
class LogSettlementToBudget {
  const LogSettlementToBudget({
    required PeopleRepository peopleRepository,
    required ExpenseRepository expenseRepository,
  }) : _people = peopleRepository,
       _expenses = expenseRepository;

  final PeopleRepository _people;
  final ExpenseRepository _expenses;

  /// [description] is the note shown on the budget transaction, already in
  /// the user's language.
  Future<ApiResult<Expense>> call(
    Settlement settlement, {
    required String description,
  }) async {
    final type = settlement.budgetType;
    if (type == null) {
      return const ResultFailure(
        ValidationFailure(FailureCode.nothingToSettle),
      );
    }
    if (settlement.isLoggedToBudget) {
      return const ResultFailure(
        ValidationFailure(FailureCode.settlementAlreadyLogged),
      );
    }

    final result = await _expenses.addExpense(
      amount: settlement.balance.magnitude,
      categoryId: ExpenseCategory.fallbackIdFor(type),
      date: settlement.settledAt,
      description: AddPersonTransaction.normalizeNote(description),
    );
    if (result case Success(:final data)) {
      // The budget transaction is what matters and it is saved. A failed
      // link only loses the note on the settlement saying it was logged.
      await _people.linkSettlementToExpense(
        settlementId: settlement.id,
        expenseId: data.id,
      );
    }
    return result;
  }
}
