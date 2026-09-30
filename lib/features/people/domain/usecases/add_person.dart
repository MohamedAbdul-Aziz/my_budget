import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/person.dart';
import '../repositories/people_repository.dart';

class AddPerson {
  const AddPerson(this._repository);

  /// Also enforced by the fields' input limits.
  static const int maxNameLength = 40;
  static const int maxPhoneLength = 20;

  static final RegExp _phoneCharacters = RegExp(r'^[0-9+\-() ]+$');

  final PeopleRepository _repository;

  Future<ApiResult<Person>> call({
    required String name,
    required int colorValue,
    String? phone,
  }) async {
    final failure = validate(name: name, phone: phone);
    if (failure != null) return ResultFailure(failure);

    return _repository.addPerson(
      name: name.trim(),
      colorValue: colorValue,
      phone: normalizePhone(phone),
    );
  }

  /// Shared with [UpdatePerson] so both paths enforce the same rules.
  static Failure? validate({required String name, String? phone}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const ValidationFailure(FailureCode.personNameRequired);
    }
    if (trimmed.length > maxNameLength) {
      return const ValidationFailure(FailureCode.personNameTooLong);
    }
    final number = normalizePhone(phone);
    if (number != null &&
        (number.length > maxPhoneLength ||
            !_phoneCharacters.hasMatch(number))) {
      return const ValidationFailure(FailureCode.phoneInvalid);
    }
    return null;
  }

  static String? normalizePhone(String? phone) {
    final trimmed = phone?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
