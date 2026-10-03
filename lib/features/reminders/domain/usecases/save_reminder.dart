import '../../../../core/error/api_result.dart';
import '../entities/daily_reminder.dart';
import '../entities/reminder_message.dart';
import '../entities/reminder_status.dart';
import '../repositories/reminder_repository.dart';

/// Stores the reminder and schedules it.
///
/// A reminder that is on asks for permission first. If the phone refuses, the
/// reminder is stored off, since it could never arrive, and the status says
/// it is blocked.
class SaveReminder {
  const SaveReminder(this._repository);

  final ReminderRepository _repository;

  Future<ApiResult<ReminderStatus>> call(
    DailyReminder reminder,
    ReminderMessage message,
  ) async {
    var saved = reminder;
    var blocked = false;
    if (reminder.enabled) {
      switch (await _repository.requestPermission()) {
        case ResultFailure(:final failure):
          return ResultFailure(failure);
        case Success(data: false):
          saved = reminder.copyWith(enabled: false);
          blocked = true;
        case Success():
          break;
      }
    }

    if (await _repository.saveReminder(saved) case ResultFailure(
      :final failure,
    )) {
      return ResultFailure(failure);
    }
    if (await _repository.schedule(saved, message) case ResultFailure(
      :final failure,
    )) {
      return ResultFailure(failure);
    }
    return Success(
      ReminderStatus(
        reminder: saved,
        supported: _repository.isSupported,
        blocked: blocked,
      ),
    );
  }
}
