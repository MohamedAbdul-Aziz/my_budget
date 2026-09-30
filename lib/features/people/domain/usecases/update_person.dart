import '../../../../core/error/api_result.dart';
import '../entities/person.dart';
import '../repositories/people_repository.dart';
import 'add_person.dart';

/// Renames a person, or changes their phone or avatar color.
class UpdatePerson {
  const UpdatePerson(this._repository);

  final PeopleRepository _repository;

  Future<ApiResult<Person>> call(
    Person existing, {
    required String name,
    required int colorValue,
    String? phone,
  }) async {
    final failure = AddPerson.validate(name: name, phone: phone);
    if (failure != null) return ResultFailure(failure);

    return _repository.updatePerson(
      Person(
        id: existing.id,
        name: name.trim(),
        phone: AddPerson.normalizePhone(phone),
        colorValue: colorValue,
        createdAt: existing.createdAt,
      ),
    );
  }
}
