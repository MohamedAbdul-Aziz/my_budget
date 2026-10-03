import '../../../../core/error/api_result.dart';
import '../entities/daily_reminder.dart';
import '../entities/reminder_message.dart';
import '../entities/reminder_status.dart';
import '../repositories/reminder_repository.dart';

/// Reads the stored reminder and schedules it again, or cancels it.
///
/// Runs at every launch, after a restore or import, and when the language
/// changes: the reminder may have been changed on another phone, the phone
/// may have moved time zone, and the wording follows the language.
class LoadReminder {
  const LoadReminder(this._repository);

  final ReminderRepository _repository;

  Future<ApiResult<ReminderStatus>> call(ReminderMessage message) async {
    final DailyReminder reminder;
    switch (await _repository.getReminder()) {
      case Success(:final data):
        reminder = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }
    if (!_repository.isSupported) {
      return Success(ReminderStatus(reminder: reminder, supported: false));
    }

    if (await _repository.schedule(reminder, message) case ResultFailure(
      :final failure,
    )) {
      return ResultFailure(failure);
    }
    if (!reminder.enabled) {
      return Success(ReminderStatus(reminder: reminder, supported: true));
    }
    // Turned on here and then blocked in the phone's settings, or turned on
    // on another phone: either way it would never arrive.
    final allowed = await _repository.notificationsAllowed();
    return allowed.map(
      (allowed) => ReminderStatus(
        reminder: reminder,
        supported: true,
        blocked: !allowed,
      ),
    );
  }
}
