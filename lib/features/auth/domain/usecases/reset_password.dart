import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
import 'confirm_sign_up.dart';
import 'sign_up.dart';

/// Sets a new password with the code from the reset email.
///
/// Both are checked here first: the code is accepted by the server before the
/// password is saved, and accepting it already signs the user in, so a
/// password the server would refuse must never get that far.
class ResetPassword {
  const ResetPassword(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<AppUser>> call({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final trimmed = code.trim();
    if (!ConfirmSignUp.isCode(trimmed)) {
      return const ResultFailure(ValidationFailure(FailureCode.codeInvalid));
    }
    if (newPassword.length < SignUp.minPasswordLength) {
      return const ResultFailure(
        ValidationFailure(FailureCode.passwordTooShort),
      );
    }
    return _repository.resetPassword(
      email: email,
      code: trimmed,
      newPassword: newPassword,
    );
  }
}
