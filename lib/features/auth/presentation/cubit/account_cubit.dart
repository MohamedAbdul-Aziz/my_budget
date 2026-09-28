import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/confirm_sign_up.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/resend_sign_up_code.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/watch_user.dart';
import 'account_state.dart';

/// Whether someone is signed in. An account is optional: the rest of the app
/// works the same without one.
class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required GetCurrentUser getCurrentUser,
    required WatchUser watchUser,
    required SignIn signIn,
    required SignUp signUp,
    required ConfirmSignUp confirmSignUp,
    required ResendSignUpCode resendSignUpCode,
    required SignOut signOut,
    required DeleteAccount deleteAccount,
  }) : _signIn = signIn,
       _signUp = signUp,
       _confirmSignUp = confirmSignUp,
       _resendSignUpCode = resendSignUpCode,
       _signOut = signOut,
       _deleteAccount = deleteAccount,
       super(switch (getCurrentUser()) {
         final user? => SignedIn(user),
         null => const SignedOut(),
       }) {
    // A link in the confirmation email signs the user in without going
    // through this cubit, and a session can also end on the server.
    _userSubscription = watchUser().listen(
      _onUserChanged,
      // A token refresh fails while offline. Supabase keeps the session and
      // retries later, so there is nothing to show.
      onError: (Object _) {},
    );
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ConfirmSignUp _confirmSignUp;
  final ResendSignUpCode _resendSignUpCode;
  final SignOut _signOut;
  final DeleteAccount _deleteAccount;

  late final StreamSubscription<AppUser?> _userSubscription;

  Future<void> signIn({required String email, required String password}) async {
    if (!_canSubmit) return;

    emit(const SignedOut(isSubmitting: true));
    switch (await _signIn(email: email, password: password)) {
      case Success(:final data):
        emit(SignedIn(data));
      // The password was right but the account was never confirmed: ask for
      // the code instead of leaving the user at a dead end.
      case ResultFailure(:final failure)
          when failure.code == FailureCode.emailNotConfirmed:
        emit(
          SignedOut(
            error: failure.code,
            unconfirmedEmail: SignUp.normalizeEmail(email),
          ),
        );
      case ResultFailure(:final failure):
        emit(SignedOut(error: failure.code));
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    if (!_canSubmit) return;

    emit(const SignedOut(isSubmitting: true));
    switch (await _signUp(email: email, password: password)) {
      case Success(data: final user?):
        emit(SignedIn(user));
      case Success():
        emit(SignedOut(unconfirmedEmail: SignUp.normalizeEmail(email)));
      case ResultFailure(:final failure):
        emit(SignedOut(error: failure.code));
    }
  }

  Future<void> confirmSignUp(String code) async {
    final email = _unconfirmedEmail;
    if (email == null || !_canSubmit) return;

    emit(SignedOut(isSubmitting: true, unconfirmedEmail: email));
    switch (await _confirmSignUp(email: email, code: code)) {
      case Success(:final data):
        emit(SignedIn(data));
      case ResultFailure(:final failure):
        emit(SignedOut(error: failure.code, unconfirmedEmail: email));
    }
  }

  /// Returns true once a new code is on its way; a failure is shown through
  /// the state like any other.
  Future<bool> resendSignUpCode() async {
    final email = _unconfirmedEmail;
    if (email == null || !_canSubmit) return false;

    emit(SignedOut(isSubmitting: true, unconfirmedEmail: email));
    final result = await _resendSignUpCode(email: email);
    emit(SignedOut(error: result.failureOrNull?.code, unconfirmedEmail: email));
    return result.isSuccess;
  }

  /// Leaves the code step, for example to sign up with a different email.
  void cancelConfirmation() {
    if (state is SignedOut) emit(const SignedOut());
  }

  Future<void> signOut() async {
    await _signOut();
    // The session is gone from the device even if the server could not be
    // told, so the user is signed out here either way.
    emit(const SignedOut());
  }

  /// Returns true once the account is gone; a failure is shown through the
  /// state.
  Future<bool> deleteAccount() async {
    final current = state;
    if (current is! SignedIn || current.isDeleting) return false;

    emit(SignedIn(current.user, isDeleting: true));
    switch (await _deleteAccount()) {
      case Success():
        emit(const SignedOut());
        return true;
      case ResultFailure(:final failure):
        emit(SignedIn(current.user, deleteError: failure.code));
        return false;
    }
  }

  String? get _unconfirmedEmail => switch (state) {
    SignedOut(:final unconfirmedEmail) => unconfirmedEmail,
    SignedIn() => null,
  };

  bool get _canSubmit => switch (state) {
    SignedOut(isSubmitting: false) => true,
    SignedOut() || SignedIn() => false,
  };

  void _onUserChanged(AppUser? user) {
    if (user != null) {
      // A token refresh reports the same user again; keep whatever the
      // account section is showing.
      if (state case SignedIn(user: final current) when current == user) {
        return;
      }
      emit(SignedIn(user));
    } else if (state is SignedIn) {
      emit(const SignedOut());
    }
    // Signed out and still signed out: keep any message or submission that
    // is showing.
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    return super.close();
  }
}
