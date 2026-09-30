import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/settlement.dart';
import '../repositories/people_repository.dart';

/// Clears every open transaction with a person. The settlement records the
/// net amount that changed hands to do it.
class SettleUp {
  const SettleUp(this._repository);

  final PeopleRepository _repository;

  Future<ApiResult<Settlement>> call(String personId) async {
    final result = await _repository.settleUp(personId);
    return switch (result) {
      Success(data: final Settlement settlement) => Success(settlement),
      Success() => const ResultFailure(
        ValidationFailure(FailureCode.nothingToSettle),
      ),
      ResultFailure(:final failure) => ResultFailure(failure),
    };
  }
}
