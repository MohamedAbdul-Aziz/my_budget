import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/reminder_status.dart';
import '../cubit/reminder_cubit.dart';
import '../cubit/reminder_state.dart';
import '../reminder_texts.dart';

/// The settings sheet's optional daily reminder: on or off, and its time.
/// Left out where the phone cannot schedule notifications.
class ReminderSection extends StatelessWidget {
  const ReminderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) => switch (state) {
        ReminderReady(:final status, :final error) when status.supported =>
          _ReminderControls(status: status, error: error),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _ReminderControls extends StatelessWidget {
  const _ReminderControls({required this.status, required this.error});

  final ReminderStatus status;
  final FailureCode? error;

  Future<void> _pickTime(BuildContext context) async {
    final reminder = status.reminder;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminder.hour, minute: reminder.minute),
    );
    if (picked == null || !context.mounted) return;
    await context.read<ReminderCubit>().setTime(
      picked.hour,
      picked.minute,
      reminderMessage(context.strings),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final errorStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    );
    final reminder = status.reminder;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(strings.reminders, style: theme.textTheme.labelLarge),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.notifications_active_outlined),
          title: Text(strings.dailyReminder),
          subtitle: Text(strings.dailyReminderHint),
          value: reminder.enabled,
          onChanged: (enabled) => context.read<ReminderCubit>().setEnabled(
            enabled,
            reminderMessage(strings),
          ),
        ),
        if (reminder.enabled)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule_rounded),
            title: Text(strings.reminderTime),
            trailing: Text(
              formats.timeOfDay(reminder.hour, reminder.minute),
              style: theme.textTheme.titleMedium,
            ),
            onTap: () => _pickTime(context),
          ),
        if (status.blocked)
          Text(strings.notificationsBlocked, style: errorStyle),
        if (error case final error?)
          Text(strings.failure(error), style: errorStyle),
      ],
    );
  }
}
