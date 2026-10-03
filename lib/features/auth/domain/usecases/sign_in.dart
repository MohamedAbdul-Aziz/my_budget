import '../../../../core/error/api_result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
import 'sign_up.dart';

class SignIn {
  const SignIn(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<AppUser>> call({
    required String email,
    required String password,
  }) async {
    final normalized = SignUp.normalizeEmail(email);
    // No account can exist that breaks these rules, so fail without a round
    // trip to the server.
    final failure = SignUp.validate(email: normalized, password: password);
    if (failure != null) return ResultFailure(failure);

    return _repository.signIn(email: normalized, password: password);
  }
}
