import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/app_lock_status.dart';

/// Every state carries the lock's settings, so the settings sheet can show
/// them whatever is happening.
sealed class AppLockState extends Equatable {
  const AppLockState(this.status);

  final AppLockStatus status;

  @override
  List<Object?> get props => [status];
}

/// Before the stored choice is read. Main reads it before the first frame,
/// so nothing is ever shown in this state.
final class AppLockLoading extends AppLockState {
  const AppLockLoading() : super(const AppLockStatus.off());
}

/// The app is showing.
final class AppLockOpen extends AppLockState {
  const AppLockOpen(super.status, {this.error});

  /// Why the last change to the setting could not be saved.
  final FailureCode? error;

  @override
  List<Object?> get props => [status, error];
}

/// The lock screen covers the app until the phone confirms the owner.
final class AppLockLocked extends AppLockState {
  const AppLockLocked(super.status, {this.checking = false});

  /// The phone's prompt is showing.
  final bool checking;

  @override
  List<Object?> get props => [status, checking];
}
