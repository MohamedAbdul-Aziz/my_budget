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

  Future<ApiResult<void>> signOut();

  /// Permanently deletes the signed-in account and the data stored with it
  /// in the cloud, and signs this phone out.
  Future<ApiResult<void>> deleteAccount();
}
