import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../expenses/domain/usecases/add_expense.dart';
import '../entities/person_transaction.dart';
import '../entities/person_transaction_type.dart';
import '../repositories/people_repository.dart';

/// Records that the user paid for a person, or the person paid for the user.
class AddPersonTransaction {
  const AddPersonTransaction(this._repository);

  /// Also enforced by the note field's input limit.
  static const int maxNoteLength = 80;

  final PeopleRepository _repository;

  Future<ApiResult<PersonTransaction>> call({
    required String personId,
    required double amount,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) async {
    final failure = validate(personId: personId, amount: amount);
    if (failure != null) return ResultFailure(failure);

    return _repository.addTransaction(
      personId: personId,
      amount: amount,
      type: type,
      date: date,
      note: normalizeNote(note),
    );
  }

  /// Money follows the same rules as everywhere else in the app. Shared with
  /// [UpdatePersonTransaction].
  static Failure? validate({required String personId, required double amount}) {
    if (personId.isEmpty) {
      return const ValidationFailure(FailureCode.personRequired);
    }
    if (amount <= 0) {
      return const ValidationFailure(FailureCode.amountRequired);
    }
    if (amount > AddExpense.maxAmount) {
      return const ValidationFailure(FailureCode.amountTooLarge);
    }
    return null;
  }

  static String? normalizeNote(String? note) {
    final trimmed = note?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed.length > maxNoteLength
        ? trimmed.substring(0, maxNoteLength)
        : trimmed;
  }
}
