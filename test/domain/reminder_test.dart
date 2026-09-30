import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/reminders/domain/entities/daily_reminder.dart';
import 'package:my_budget/features/reminders/domain/entities/reminder_message.dart';
import 'package:my_budget/features/reminders/domain/entities/reminder_status.dart';
import 'package:my_budget/features/reminders/domain/usecases/load_reminder.dart';
import 'package:my_budget/features/reminders/domain/usecases/save_reminder.dart';

import '../presentation/fakes.dart';

const _words = ReminderMessage(
  title: "Log today's spending",
  body: 'Take a moment to add what you spent today.',
  channelName: 'Daily reminder',
);
const _halfPastSeven = DailyReminder(enabled: true, hour: 7, minute: 30);

void main() {
  late FakeReminderRepository repository;

  setUp(() => repository = FakeReminderRepository());

  group('LoadReminder', () {
    test('schedules the stored reminder again, in the given words', () async {
      repository.reminder = _halfPastSeven;

      final status = (await LoadReminder(repository)(_words)).dataOrNull;

      expect(
        status,
        const ReminderStatus(reminder: _halfPastSeven, supported: true),
      );
      expect(repository.scheduled, _halfPastSeven);
      expect(repository.scheduledMessage, _words);
      expect(repository.permissionRequests, 0);
    });

    test('cancels a reminder turned off on another phone', () async {
      repository
        ..scheduled = _halfPastSeven
        ..reminder = _halfPastSeven.copyWith(enabled: false);

      await LoadReminder(repository)(_words);

      expect(repository.scheduled, isNull);
    });

    test('says when the phone blocks a reminder that is on', () async {
      repository
        ..reminder = _halfPastSeven
        ..allowed = false;

      final status = (await LoadReminder(repository)(_words)).dataOrNull!;

      expect(status.blocked, isTrue);
      expect(status.reminder.enabled, isTrue);
    });

    test('schedules nothing where notifications are not supported', () async {
      repository
        ..reminder = _halfPastSeven
        ..supported = false;

      final status = (await LoadReminder(repository)(_words)).dataOrNull!;

      expect(status.supported, isFalse);
      expect(repository.scheduled, isNull);
    });
  });

  group('SaveReminder', () {
    test(
      'turning it on asks for permission, then stores and schedules it',
      () async {
        repository.allowed = false;

        final status = (await SaveReminder(repository)(
          _halfPastSeven,
          _words,
        )).dataOrNull;

        expect(repository.permissionRequests, 1);
        expect(
          status,
          const ReminderStatus(reminder: _halfPastSeven, supported: true),
        );
        expect(repository.reminder, _halfPastSeven);
        expect(repository.scheduled, _halfPastSeven);
      },
    );

    test('a refused permission stores it off and says it is blocked', () async {
      repository
        ..allowed = false
        ..grantOnRequest = false;

      final status = (await SaveReminder(repository)(
        _halfPastSeven,
        _words,
      )).dataOrNull!;

      expect(status.blocked, isTrue);
      expect(status.reminder, _halfPastSeven.copyWith(enabled: false));
      // The chosen time is kept for when it is allowed.
      expect(repository.reminder, _halfPastSeven.copyWith(enabled: false));
      expect(repository.scheduled, isNull);
    });

    test('turning it off cancels it without asking for anything', () async {
      repository
        ..reminder = _halfPastSeven
        ..scheduled = _halfPastSeven;

      await SaveReminder(repository)(
        _halfPastSeven.copyWith(enabled: false),
        _words,
      );

      expect(repository.permissionRequests, 0);
      expect(repository.reminder.enabled, isFalse);
      expect(repository.scheduled, isNull);
    });
  });
}
