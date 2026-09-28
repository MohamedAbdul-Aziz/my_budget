import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Validates then creates an account. Succeeds with null while the account
/// waits to be confirmed with the code emailed to it.
class SignUp {
  const SignUp(this._repository);

  static const int minPasswordLength = 6;

  /// Deliberately loose: the confirmation email is the real test of an
  /// address, this only catches typos before a round trip.
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final AuthRepository _repository;

  Future<ApiResult<AppUser?>> call({
    required String email,
    required String password,
  }) async {
    final normalized = normalizeEmail(email);
    final failure = validate(email: normalized, password: password);
    if (failure != null) return ResultFailure(failure);

    return _repository.signUp(email: normalized, password: password);
  }

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// Shared with [SignIn] so both paths enforce the same rules. Expects an
  /// email that has already been through [normalizeEmail].
  static Failure? validate({required String email, required String password}) {
    if (!_emailPattern.hasMatch(email)) {
      return const ValidationFailure(FailureCode.emailInvalid);
    }
    if (password.length < minPasswordLength) {
      return const ValidationFailure(FailureCode.passwordTooShort);
    }
    return null;
  }
}
