import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import 'sign_up.dart';

/// Emails a code for choosing a new password, once the address looks like
/// one.
class SendPasswordReset {
  const SendPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call({required String email}) async {
    final normalized = SignUp.normalizeEmail(email);
    if (!SignUp.isEmail(normalized)) {
      return const ResultFailure(ValidationFailure(FailureCode.emailInvalid));
    }
    return _repository.sendPasswordReset(email: normalized);
  }
}
