import '../../../../core/error/api_result.dart';
import '../entities/person_ledger.dart';
import '../repositories/people_repository.dart';

class GetPersonLedger {
  const GetPersonLedger(this._repository);

  final PeopleRepository _repository;

  Future<ApiResult<PersonLedger>> call(String personId) =>
      _repository.getLedger(personId);
}
