import '../../../../core/error/api_result.dart';
import '../entities/person.dart';
import '../entities/person_ledger.dart';
import '../entities/person_summary.dart';
import '../entities/person_transaction.dart';
import '../entities/person_transaction_type.dart';
import '../entities/settlement.dart';

abstract interface class PeopleRepository {
  /// Every person with their open balance, in alphabetical order.
  Future<ApiResult<List<PersonSummary>>> getPeople();

  /// Fails with a not-found failure once the person is deleted.
  Future<ApiResult<PersonLedger>> getLedger(String personId);

  Future<ApiResult<Person>> addPerson({
    required String name,
    required int colorValue,
    String? phone,
  });

  Future<ApiResult<Person>> updatePerson(Person person);

  /// Deletes the person with everything recorded with them. Budget
  /// transactions logged for their settlements stay: that money did move.
  Future<ApiResult<void>> deletePerson(String personId);

  Future<ApiResult<PersonTransaction>> addTransaction({
    required String personId,
    required double amount,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  });

  /// Keeps the values it replaces in the transaction's change log. Fails
  /// with `FailureCode.transactionSettled` for a settled transaction.
  Future<ApiResult<PersonTransaction>> updateTransaction({
    required String id,
    required double amount,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  });

  /// Fails with `FailureCode.transactionSettled` for a settled transaction.
  Future<ApiResult<void>> deleteTransaction(String id);

  /// Clears every open transaction with the person in one step. Succeeds
  /// with null when there was nothing open to settle.
  Future<ApiResult<Settlement?>> settleUp(String personId);

  /// Remembers which budget transaction was logged for a settlement.
  Future<ApiResult<void>> linkSettlementToExpense({
    required String settlementId,
    required String expenseId,
  });
}
