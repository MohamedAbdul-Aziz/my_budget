import '../../../../core/error/api_result.dart';
import '../../domain/entities/daily_reminder.dart';
import '../../domain/entities/reminder_message.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_data_source.dart';
import '../datasources/reminder_notifications_data_source.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  const ReminderRepositoryImpl({
    required ReminderLocalDataSource local,
    required ReminderNotificationsDataSource notifications,
  }) : _local = local,
       _notifications = notifications;

  final ReminderLocalDataSource _local;
  final ReminderNotificationsDataSource _notifications;

  @override
  bool get isSupported => _notifications.isSupported;

  @override
  Future<ApiResult<DailyReminder>> getReminder() =>
      ApiResult.guard(_local.read);

  @override
  Future<ApiResult<void>> saveReminder(DailyReminder reminder) =>
      ApiResult.guard(() => _local.write(reminder));

  @override
  Future<ApiResult<bool>> notificationsAllowed() =>
      ApiResult.guard(_notifications.areAllowed);

  @override
  Future<ApiResult<bool>> requestPermission() =>
      ApiResult.guard(_notifications.requestPermission);

  @override
  Future<ApiResult<void>> schedule(
    DailyReminder reminder,
    ReminderMessage message,
  ) => ApiResult.guard(
    () => reminder.enabled
        ? _notifications.scheduleDaily(
            hour: reminder.hour,
            minute: reminder.minute,
            message: message,
          )
        : _notifications.cancel(),
  );
}
