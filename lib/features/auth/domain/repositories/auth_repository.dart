import '../../../../core/error/api_result.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  /// The user whose session was restored at startup, or null. Answered from
  /// the device, so it works offline.
  AppUser? get currentUser;

  /// Emits whenever someone signs in or out, including when it happens outside
  /// the app's own calls: a confirmation link opening the app, or a session
  /// ending on the server.
  Stream<AppUser?> get userChanges;

  Future<ApiResult<AppUser>> signIn({
    required String email,
    required String password,
  });

  /// Succeeds with null when the account was created but has to be confirmed
  /// with the code emailed to it before it can be used.
  Future<ApiResult<AppUser?>> signUp({
    required String email,
    required String password,
  });

  /// Confirms a new account with the code from its confirmation email, which
  /// also signs the user in.
  Future<ApiResult<AppUser>> confirmSignUp({
    required String email,
    required String code,
  });

  Future<ApiResult<void>> resendSignUpCode({required String email});

  /// Emails a code for choosing a new password. Succeeds for any address,
  /// registered or not, so nobody can probe which emails have an account.
  Future<ApiResult<void>> sendPasswordReset({required String email});

  /// Checks the code from the reset email and saves [newPassword]. Checking
  /// the code signs the user in, so if only saving the password fails, the
  /// user is signed in with the old one.
  Future<ApiResult<AppUser>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<ApiResult<void>> signOut();

  /// Permanently deletes the signed-in account and the data stored with it
  /// in the cloud, and signs this phone out.
  Future<ApiResult<void>> deleteAccount();
}
