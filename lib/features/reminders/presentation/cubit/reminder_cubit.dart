import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../domain/entities/daily_reminder.dart';
import '../../domain/entities/reminder_message.dart';
import '../../domain/usecases/load_reminder.dart';
import '../../domain/usecases/save_reminder.dart';
import 'reminder_state.dart';

/// The daily reminder to log the day's spending. Every call takes the
/// wording in the current language, since scheduling it writes the
/// notification's text.
class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit({
    required LoadReminder loadReminder,
    required SaveReminder saveReminder,
  }) : _loadReminder = loadReminder,
       _saveReminder = saveReminder,
       super(const ReminderLoading());

  final LoadReminder _loadReminder;
  final SaveReminder _saveReminder;

  /// Reads the stored reminder and schedules it again.
  Future<void> load(ReminderMessage message) async {
    emit(switch (await _loadReminder(message)) {
      Success(:final data) => ReminderReady(data),
      ResultFailure(:final failure) => ReminderLoadFailure(failure.code),
    });
  }

  Future<void> setEnabled(bool enabled, ReminderMessage message) =>
      _save((reminder) => reminder.copyWith(enabled: enabled), message);

  Future<void> setTime(int hour, int minute, ReminderMessage message) => _save(
    (reminder) => reminder.copyWith(hour: hour, minute: minute),
    message,
  );

  Future<void> _save(
    DailyReminder Function(DailyReminder current) change,
    ReminderMessage message,
  ) async {
    if (state case ReminderReady(:final status)) {
      final result = await _saveReminder(change(status.reminder), message);
      emit(switch (result) {
        Success(:final data) => ReminderReady(data),
        ResultFailure(:final failure) => ReminderReady(
          status,
          error: failure.code,
        ),
      });
    }
  }
}
