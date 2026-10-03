import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/l10n/app_strings.dart';
import 'package:my_budget/features/reminders/domain/entities/daily_reminder.dart';
import 'package:my_budget/features/reminders/presentation/reminder_texts.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  final reminderSwitch = find.widgetWithText(SwitchListTile, 'Daily reminder');

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  Future<void> tapInSheet(WidgetTester tester, Finder target) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  String timeOfDay(int hour, int minute) =>
      sl<SettingsCubit>().state.formats.timeOfDay(hour, minute);

  testWidgets('turning the reminder on schedules it for 9 PM', (tester) async {
    final harness = await bootApp(tester);
    await openSettings(tester);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Time'), findsNothing);

    await tapInSheet(tester, reminderSwitch);

    const nineInTheEvening = DailyReminder(enabled: true);
    expect(harness.reminder.reminder, nineInTheEvening);
    expect(harness.reminder.scheduled, nineInTheEvening);
    expect(harness.reminder.scheduledMessage?.title, "Log today's spending");
    expect(find.text('Time'), findsOneWidget);
    expect(find.text(timeOfDay(21, 0)), findsOneWidget);
  });

  testWidgets('choosing another time reschedules it', (tester) async {
    final harness = await bootApp(
      tester,
      before: (harness) =>
          harness.reminder.reminder = const DailyReminder(enabled: true),
    );
    await openSettings(tester);

    await tapInSheet(tester, find.text('Time'));
    // Type the time rather than turning the dial.
    await tester.tap(find.byTooltip('Switch to text input mode'));
    await tester.pumpAndSettle();
    final fields = find.descendant(
      of: find.byType(Dialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), '8');
    await tester.enterText(fields.at(1), '15');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    const quarterPastEight = DailyReminder(enabled: true, hour: 20, minute: 15);
    expect(harness.reminder.reminder, quarterPastEight);
    expect(harness.reminder.scheduled, quarterPastEight);
    expect(find.text(timeOfDay(20, 15)), findsOneWidget);
  });

  testWidgets('turning it off cancels it and keeps the time', (tester) async {
    final harness = await bootApp(
      tester,
      before: (harness) => harness.reminder.reminder = const DailyReminder(
        enabled: true,
        hour: 7,
        minute: 30,
      ),
    );
    await openSettings(tester);

    await tapInSheet(tester, reminderSwitch);

    expect(harness.reminder.reminder, const DailyReminder(hour: 7, minute: 30));
    expect(harness.reminder.scheduled, isNull);
    expect(find.text('Time'), findsNothing);
  });

  testWidgets('a refused permission leaves it off and says why', (
    tester,
  ) async {
    final harness = await bootApp(
      tester,
      before: (harness) => harness.reminder
        ..allowed = false
        ..grantOnRequest = false,
    );
    await openSettings(tester);

    await tapInSheet(tester, reminderSwitch);

    expect(harness.reminder.permissionRequests, 1);
    expect(harness.reminder.reminder.enabled, isFalse);
    expect(harness.reminder.scheduled, isNull);
    expect(tester.widget<SwitchListTile>(reminderSwitch).value, isFalse);
    expect(
      find.text(
        "Notifications are off for this app. Allow them in your phone's "
        'settings.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('switching the language rewrites the scheduled reminder', (
    tester,
  ) async {
    final harness = await bootApp(
      tester,
      before: (harness) =>
          harness.reminder.reminder = const DailyReminder(enabled: true),
    );
    // Scheduled again at launch, in the language the app opened in.
    expect(harness.reminder.scheduledMessage?.title, "Log today's spending");

    await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
    await tester.pumpAndSettle();

    expect(
      harness.reminder.scheduledMessage,
      reminderMessage(AppStrings.forLanguageCode('ar')),
    );
  });

  testWidgets('a restore brings the reminder back and schedules it', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    harness.auth.openConfirmationLink('mohamed@example.com');
    await tester.pumpAndSettle();
    // The cloud copy has the reminder on at 8 AM.
    const eightInTheMorning = DailyReminder(enabled: true, hour: 8);
    harness.sync.onRestore = () async =>
        harness.reminder.reminder = eightInTheMorning;
    await openSettings(tester);

    await tapInSheet(tester, find.text('Restore'));

    expect(harness.reminder.scheduled, eightInTheMorning);
    expect(find.text(timeOfDay(8, 0)), findsOneWidget);
  });

  testWidgets('is left out where the phone cannot show notifications', (
    tester,
  ) async {
    await bootApp(
      tester,
      before: (harness) => harness.reminder.supported = false,
    );
    await openSettings(tester);

    expect(find.text('Reminders'), findsNothing);
    expect(reminderSwitch, findsNothing);
  });
}
