import '../../../core/di/injection.dart';
import '../../../core/l10n/app_strings.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../domain/entities/reminder_message.dart';

/// The reminder's wording in [strings]' language.
ReminderMessage reminderMessage(AppStrings strings) => ReminderMessage(
  title: strings.reminderNotificationTitle,
  body: strings.reminderNotificationBody,
  channelName: strings.dailyReminder,
);

/// The wording in the language the app is showing, for callers with no
/// widget tree to read it from: the launch, and the listeners above
/// MaterialApp.
ReminderMessage currentReminderMessage() => reminderMessage(
  AppStrings.forLanguageCode(sl<SettingsCubit>().state.languageCode),
);
