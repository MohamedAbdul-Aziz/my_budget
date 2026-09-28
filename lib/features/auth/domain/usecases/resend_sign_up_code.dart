import '../../../../core/error/api_result.dart';
import '../repositories/auth_repository.dart';

class ResendSignUpCode {
  const ResendSignUpCode(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call({required String email}) =>
      _repository.resendSignUpCode(email: email);
}
