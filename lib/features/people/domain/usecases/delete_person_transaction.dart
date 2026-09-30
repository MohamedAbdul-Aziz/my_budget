import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/person_transaction.dart';
import '../repositories/people_repository.dart';

class DeletePersonTransaction {
  const DeletePersonTransaction(this._repository);

  final PeopleRepository _repository;

  Future<ApiResult<void>> call(PersonTransaction transaction) async {
    // A settled transaction is part of its settlement's total.
    if (transaction.isSettled) {
      return const ResultFailure(
        ValidationFailure(FailureCode.transactionSettled),
      );
    }
    return _repository.deleteTransaction(transaction.id);
  }
}
