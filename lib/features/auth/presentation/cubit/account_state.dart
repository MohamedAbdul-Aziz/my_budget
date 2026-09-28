import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

final class SignedOut extends AccountState {
  const SignedOut({
    this.isSubmitting = false,
    this.error,
    this.unconfirmedEmail,
  });

  /// A request is waiting on the server.
  final bool isSubmitting;

  /// Why the last attempt failed; the UI turns it into a sentence.
  final FailureCode? error;

  /// An account that exists but still needs the code from its confirmation
  /// email. While set, the sign-in page asks for that code.
  final String? unconfirmedEmail;

  @override
  List<Object?> get props => [isSubmitting, error, unconfirmedEmail];
}

final class SignedIn extends AccountState {
  const SignedIn(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}
