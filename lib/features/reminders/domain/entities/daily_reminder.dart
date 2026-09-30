import 'package:equatable/equatable.dart';

/// The optional nudge to log the day's spending: whether it is on, and the
/// time of day it arrives on the phone's own clock.
class DailyReminder extends Equatable {
  const DailyReminder({
    this.enabled = false,
    this.hour = defaultHour,
    this.minute = 0,
  }) : assert(hour >= 0 && hour < 24),
       assert(minute >= 0 && minute < 60);

  /// Evening, once most of the day's spending has happened.
  static const int defaultHour = 21;

  final bool enabled;
  final int hour;
  final int minute;

  DailyReminder copyWith({bool? enabled, int? hour, int? minute}) =>
      DailyReminder(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );

  @override
  List<Object?> get props => [enabled, hour, minute];
}
