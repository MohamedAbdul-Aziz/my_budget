import '../../../../core/error/api_result.dart';
import '../entities/daily_reminder.dart';
import '../entities/reminder_message.dart';

abstract interface class ReminderRepository {
  /// Whether this platform can schedule notifications at all.
  bool get isSupported;

  Future<ApiResult<DailyReminder>> getReminder();

  Future<ApiResult<void>> saveReminder(DailyReminder reminder);

  /// Whether the phone currently lets the app show notifications.
  Future<ApiResult<bool>> notificationsAllowed();

  /// Asks the user to allow notifications, if the phone still asks; true once
  /// they are allowed.
  Future<ApiResult<bool>> requestPermission();

  /// Replaces whatever is scheduled: a notification every day at
  /// [reminder]'s time, or nothing when it is off.
  Future<ApiResult<void>> schedule(
    DailyReminder reminder,
    ReminderMessage message,
  );
}
