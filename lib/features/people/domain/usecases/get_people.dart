import '../../../../core/error/api_result.dart';
import '../entities/person_summary.dart';
import '../repositories/people_repository.dart';

class GetPeople {
  const GetPeople(this._repository);

  final PeopleRepository _repository;

  Future<ApiResult<List<PersonSummary>>> call() => _repository.getPeople();
}
