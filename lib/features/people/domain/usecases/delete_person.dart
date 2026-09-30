import '../../../../core/error/api_result.dart';
import '../repositories/people_repository.dart';

/// Removes a person along with their transactions, change logs and
/// settlements.
class DeletePerson {
  const DeletePerson(this._repository);

  final PeopleRepository _repository;

  Future<ApiResult<void>> call(String personId) =>
      _repository.deletePerson(personId);
}
