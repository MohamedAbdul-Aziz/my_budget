import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Confirms a new account with the code from its confirmation email.
class ConfirmSignUp {
  const ConfirmSignUp(this._repository);

  /// Supabase sends 6 digits by default and allows up to 10 when the project
  /// is configured for longer codes.
  static final RegExp _codePattern = RegExp(r'^\d{6,10}$');

  final AuthRepository _repository;

  /// Whether a trimmed [code] looks like one Supabase sends. Shared with
  /// [ResetPassword]'s code.
  static bool isCode(String code) => _codePattern.hasMatch(code);

  Future<ApiResult<AppUser>> call({
    required String email,
    required String code,
  }) async {
    final trimmed = code.trim();
    if (!isCode(trimmed)) {
      return const ResultFailure(ValidationFailure(FailureCode.codeInvalid));
    }
    return _repository.confirmSignUp(email: email, code: trimmed);
  }
}
