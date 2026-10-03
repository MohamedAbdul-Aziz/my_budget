import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/reminder_status.dart';

sealed class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object?> get props => [];
}

final class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

final class ReminderReady extends ReminderState {
  const ReminderReady(this.status, {this.error});

  final ReminderStatus status;

  /// Why the last change could not be saved; the previous reminder stays.
  final FailureCode? error;

  @override
  List<Object?> get props => [status, error];
}

final class ReminderLoadFailure extends ReminderState {
  const ReminderLoadFailure(this.error);

  final FailureCode error;

  @override
  List<Object?> get props => [error];
}
