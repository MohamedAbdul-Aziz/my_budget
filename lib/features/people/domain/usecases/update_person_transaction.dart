import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/person_transaction.dart';
import '../entities/person_transaction_type.dart';
import '../repositories/people_repository.dart';
import 'add_person_transaction.dart';

/// Changes an open transaction. The values it replaces go into the
/// transaction's change log.
class UpdatePersonTransaction {
  const UpdatePersonTransaction(this._repository);

  final PeopleRepository _repository;

  Future<ApiResult<PersonTransaction>> call(
    PersonTransaction existing, {
    required double amount,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) async {
    // A settled transaction is part of its settlement's total.
    if (existing.isSettled) {
      return const ResultFailure(
        ValidationFailure(FailureCode.transactionSettled),
      );
    }
    final failure = AddPersonTransaction.validate(
      personId: existing.personId,
      amount: amount,
    );
    if (failure != null) return ResultFailure(failure);

    return _repository.updateTransaction(
      id: existing.id,
      amount: amount,
      type: type,
      date: date,
      note: AddPersonTransaction.normalizeNote(note),
    );
  }
}
