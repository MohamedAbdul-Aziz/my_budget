import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/entities/period.dart';

void main() {
  // Wednesday 14 October 2026.
  final wednesday = DateTime(2026, 10, 14, 18, 30);

  group('a period starts and ends', () {
    test('a day runs midnight to midnight', () {
      final day = Period(PeriodKind.day, wednesday);
      expect(day.start, DateTime(2026, 10, 14));
      expect(day.endExclusive, DateTime(2026, 10, 15));
      expect(day.contains(wednesday), isTrue);
      expect(day.contains(DateTime(2026, 10, 15)), isFalse);
    });

    test('a week starts on the day the language starts it', () {
      expect(
        Period(PeriodKind.week, wednesday).start,
        DateTime(2026, 10, 12), // Monday
      );
      expect(
        Period(PeriodKind.week, wednesday, firstWeekday: DateTime.sunday).start,
        DateTime(2026, 10, 11),
      );
      final arabic = Period(
        PeriodKind.week,
        wednesday,
        firstWeekday: DateTime.saturday,
      );
      expect(arabic.start, DateTime(2026, 10, 10));
      expect(arabic.lastDay, DateTime(2026, 10, 16));
      // A week starting on the day itself.
      expect(
        Period(
          PeriodKind.week,
          DateTime(2026, 10, 10),
          firstWeekday: DateTime.saturday,
        ).start,
        DateTime(2026, 10, 10),
      );
    });

    test('a week may span two months and two years', () {
      final week = Period(PeriodKind.week, DateTime(2027, 1, 1));
      expect(week.start, DateTime(2026, 12, 28));
      expect(week.endExclusive, DateTime(2027, 1, 4));
    });

    test('a month and a year', () {
      final month = Period(PeriodKind.month, wednesday);
      expect(month.start, DateTime(2026, 10));
      expect(month.endExclusive, DateTime(2026, 11));
      expect(month.month, const Month(2026, 10));
      final year = Period(PeriodKind.year, wednesday);
      expect(year.start, DateTime(2026));
      expect(year.endExclusive, DateTime(2027));
    });
  });

  group('stepping', () {
    test('by one of its own kind', () {
      expect(
        Period(PeriodKind.day, wednesday).shift(-1).start,
        DateTime(2026, 10, 13),
      );
      expect(
        Period(PeriodKind.week, wednesday).shift(1).start,
        DateTime(2026, 10, 19),
      );
      expect(
        Period(PeriodKind.month, wednesday).shift(3).start,
        DateTime(2027, 1),
      );
      expect(
        Period(PeriodKind.year, wednesday).shift(-2).start,
        DateTime(2024),
      );
    });

    test('keeps the day of the month where it exists', () {
      final endOfJanuary = Period(PeriodKind.month, DateTime(2027, 1, 31));
      expect(endOfJanuary.shift(1).anchor, DateTime(2027, 2, 28));
      expect(endOfJanuary.shift(2).anchor, DateTime(2027, 3, 31));
      final leapDay = Period(PeriodKind.year, DateTime(2028, 2, 29));
      expect(leapDay.shift(1).anchor, DateTime(2029, 2, 28));
    });

    test('changing the kind keeps the picked day', () {
      final week = Period(
        PeriodKind.month,
        wednesday,
      ).withKind(PeriodKind.week);
      expect(week.start, DateTime(2026, 10, 12));
      expect(week.withKind(PeriodKind.month).anchor, DateTime(2026, 10, 14));
    });

    test('knows when it is over', () {
      final today = Period(PeriodKind.day, wednesday);
      expect(today.endsBefore(wednesday), isFalse);
      expect(today.shift(-1).endsBefore(wednesday), isTrue);
      expect(Period(PeriodKind.year, wednesday).endsBefore(wednesday), isFalse);
    });
  });
}
