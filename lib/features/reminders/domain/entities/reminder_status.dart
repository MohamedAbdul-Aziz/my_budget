import 'package:equatable/equatable.dart';

import 'daily_reminder.dart';

/// The stored reminder, and what this phone allows.
class ReminderStatus extends Equatable {
  const ReminderStatus({
    required this.reminder,
    required this.supported,
    this.blocked = false,
  });

  final DailyReminder reminder;

  /// False where the app cannot schedule notifications (desktop), so the
  /// settings leave the reminder out.
  final bool supported;

  /// The user wants the reminder but the phone does not let the app show
  /// notifications, so it would never arrive.
  final bool blocked;

  @override
  List<Object?> get props => [reminder, supported, blocked];
}
