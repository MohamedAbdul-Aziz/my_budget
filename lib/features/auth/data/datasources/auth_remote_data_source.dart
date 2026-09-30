import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';

abstract interface class AuthRemoteDataSource {
  AppUser? get currentUser;

  Stream<AppUser?> get userChanges;

  Future<AppUser> signIn({required String email, required String password});

  /// Null when the account waits to be confirmed with an emailed code.
  Future<AppUser?> signUp({required String email, required String password});

  Future<AppUser> confirmSignUp({required String email, required String code});

  Future<void> resendSignUpCode({required String email});

  /// Emails a code that lets the user choose a new password.
  Future<void> sendPasswordReset({required String email});

  /// Checks the emailed code, which signs the user in, then saves the new
  /// password.
  Future<AppUser> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<void> signOut();

  /// Permanently deletes the signed-in account and everything stored with it
  /// in the cloud, then signs this phone out.
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  /// The confirmation email carries a code the user types into the app. If
  /// the "Confirm signup" template also includes the link, this is where the
  /// link leads: a deep link that opens this app, where Supabase finishes
  /// signing the user in. It must be listed under Authentication > URL
  /// Configuration > Redirect URLs, or Supabase uses the Site URL instead.
  static const String confirmationRedirect =
      'com.mohamed.mybudget://login-callback';

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  AppUser? get currentUser => switch (_auth.currentUser) {
    final user? => _toAppUser(user),
    null => null,
  };

  /// Supabase replays its whole event history to each new listener, so every
  /// event is answered with who is signed in now rather than who was signed
  /// in when it fired.
  @override
  Stream<AppUser?> get userChanges =>
      _auth.onAuthStateChange.map((_) => currentUser).distinct();

  @override
  Future<AppUser> signIn({required String email, required String password}) =>
      _guard(() async {
        final response = await _auth.signInWithPassword(
          email: email,
          password: password,
        );
        return _toAppUser(response.user!);
      });

  @override
  Future<AppUser?> signUp({required String email, required String password}) =>
      _guard(() async {
        final response = await _auth.signUp(
          email: email,
          password: password,
          emailRedirectTo: confirmationRedirect,
        );
        // No session means Supabase sent a confirmation email first. An
        // address that already has an account looks the same, so nobody can
        // probe which emails are registered.
        final user = response.user;
        return response.session == null || user == null
            ? null
            : _toAppUser(user);
      });

  /// Supabase documents `email` as the type for the code from a "Confirm
  /// signup" email, and `signup` as the type for sending that email again.
  @override
  Future<AppUser> confirmSignUp({
    required String email,
    required String code,
  }) => _guard(() async {
    final response = await _auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: code,
    );
    return _toAppUser(response.user!);
  });

  @override
  Future<void> resendSignUpCode({required String email}) => _guard(
    () => _auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: confirmationRedirect,
    ),
  );

  /// The "Reset Password" email template must show `{{ .Token }}`, the code
  /// the user types into the app, the same way the "Confirm signup" template
  /// does. No redirect is passed: the reset happens in the app, not through
  /// a link.
  @override
  Future<void> sendPasswordReset({required String email}) =>
      _guard(() => _auth.resetPasswordForEmail(email));

  @override
  Future<AppUser> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _guard(() async {
    final response = await _auth.verifyOTP(
      type: OtpType.recovery,
      email: email,
      token: code,
    );
    try {
      await _auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (error) {
      // The "new" password is the one the account already has, so the user
      // knows it: nothing to change.
      if (error.code != 'same_password') rethrow;
    }
    return _toAppUser(response.user!);
  });

  /// Supabase drops the session on the device before telling the server, so
  /// this signs the user out locally even when offline.
  @override
  Future<void> signOut() => _guard(_auth.signOut);

  /// Deleting a user needs the project's secret key, which must never ship
  /// in the app. The `delete-account` Edge Function holds it, works out the
  /// account from the caller's own session, and deletes only that one. The
  /// cloud tables reference the user with `on delete cascade`, so the backup
  /// goes with it.
  @override
  Future<void> deleteAccount() async {
    try {
      await _client.functions.invoke('delete-account');
    } on FunctionException catch (error) {
      throw error.status == 401
          ? AuthFailure(FailureCode.signInRequired, '$error')
          : AuthFailure(FailureCode.accountDeletionFailed, '$error');
    } on SocketException catch (error) {
      throw NetworkFailure('$error');
    } on http.ClientException catch (error) {
      throw NetworkFailure('$error');
    }

    // The account no longer exists, so telling the server about the sign-out
    // can only fail, and that changes nothing: the session is dropped from
    // this phone before the server is contacted.
    try {
      await _auth.signOut();
    } on Exception {
      // Nothing left to undo.
    }
  }

  static AppUser _toAppUser(User user) =>
      AppUser(id: user.id, email: user.email ?? '');

  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthRetryableFetchException catch (error) {
      throw NetworkFailure(error.message);
    } on AuthWeakPasswordException catch (error) {
      throw ValidationFailure(FailureCode.passwordTooShort, error.message);
    } on AuthException catch (error) {
      throw switch (error.code) {
        'invalid_credentials' => AuthFailure(
          FailureCode.invalidCredentials,
          error.message,
        ),
        'email_not_confirmed' => AuthFailure(
          FailureCode.emailNotConfirmed,
          error.message,
        ),
        'user_already_exists' ||
        'email_exists' => AuthFailure(FailureCode.emailTaken, error.message),
        // Supabase answers a wrong code and an expired one the same way.
        'otp_expired' => AuthFailure(FailureCode.codeInvalid, error.message),
        'email_address_invalid' => ValidationFailure(
          FailureCode.emailInvalid,
          error.message,
        ),
        'over_request_rate_limit' || 'over_email_send_rate_limit' =>
          AuthFailure(FailureCode.tooManyAttempts, error.message),
        _ => UnknownFailure('$error'),
      };
    }
  }
}
