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

  Future<void> signOut();
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

  /// Supabase drops the session on the device before telling the server, so
  /// this signs the user out locally even when offline.
  @override
  Future<void> signOut() => _guard(_auth.signOut);

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
