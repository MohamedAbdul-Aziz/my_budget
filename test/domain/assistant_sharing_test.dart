import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/features/assistant/data/models/assistant_sharing_model.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_sharing.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

void main() {
  final now = DateTime(2026, 10, 10, 15, 30);

  group('resolve', () {
    test('the default is the last three months, up to today', () {
      final range = AssistantSharing.defaults.resolve(now);
      expect(range.months, const [
        Month(2026, 10),
        Month(2026, 9),
        Month(2026, 8),
      ]);
      expect(range.start, DateTime(2026, 8));
      expect(range.endExclusive, DateTime(2026, 10, 11));
    });

    test('presets', () {
      Iterable<Month> months(AssistantRange range) =>
          AssistantSharing(range: range).resolve(now).months;
      expect(months(AssistantRange.thisMonth), const [Month(2026, 10)]);
      expect(months(AssistantRange.last6Months).last, const Month(2026, 5));
      expect(months(AssistantRange.thisYear), hasLength(10));
      expect(months(AssistantRange.thisYear).last, const Month(2026, 1));
    });

    test('a custom range keeps its days and the months it touches', () {
      final range = AssistantSharing(
        range: AssistantRange.custom,
        customStart: DateTime(2025, 12, 20),
        customEnd: DateTime(2026, 1, 5),
      ).resolve(now);
      expect(range.start, DateTime(2025, 12, 20));
      expect(range.lastDay, DateTime(2026, 1, 5));
      expect(range.months, const [Month(2026, 1), Month(2025, 12)]);
    });

    test('a long custom range sends at most twelve months, the newest', () {
      final range = AssistantSharing(
        range: AssistantRange.custom,
        customStart: DateTime(2020, 1, 1),
        customEnd: DateTime(2026, 10, 1),
      ).resolve(now);
      expect(range.months, hasLength(AssistantSharing.maxMonths));
      expect(range.months.first, const Month(2026, 10));
    });

    test(
      'an incomplete or backwards custom range falls back to the default',
      () {
        final fallback = AssistantSharing.defaults.resolve(now);
        expect(
          const AssistantSharing(range: AssistantRange.custom).resolve(now),
          fallback,
        );
        expect(
          AssistantSharing(
            range: AssistantRange.custom,
            customStart: DateTime(2026, 10, 5),
            customEnd: DateTime(2026, 10, 1),
          ).resolve(now),
          fallback,
        );
      },
    );
  });

  test('notes are sent only with transactions', () {
    expect(
      const AssistantSharing(descriptions: true).sendsDescriptions,
      isFalse,
    );
    expect(
      const AssistantSharing(
        transactions: true,
        descriptions: true,
      ).sendsDescriptions,
      isTrue,
    );
  });

  group('stored form', () {
    test('round-trips every choice', () {
      final sharing = AssistantSharing(
        range: AssistantRange.custom,
        customStart: DateTime(2026, 9, 1),
        customEnd: DateTime(2026, 9, 30),
        transactions: true,
        descriptions: true,
        recurring: true,
        people: true,
      );
      expect(
        AssistantSharingModel.decode(AssistantSharingModel.encode(sharing)),
        sharing,
      );
    });

    test('nothing saved, damaged or odd values read as the default', () {
      for (final stored in [
        null,
        'not json',
        '[1, 2]',
        '{"range": 5, "transactions": "yes", "from": 7}',
        '{"range": "someday"}',
      ]) {
        expect(
          AssistantSharingModel.decode(stored),
          AssistantSharing.defaults,
          reason: stored,
        );
      }
    });
  });
}
