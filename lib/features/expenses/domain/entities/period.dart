import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'month.dart';

/// How long a stretch of time the home screen shows.
enum PeriodKind { day, week, month, year }

/// One day, week, month or year, around the day the user picked.
///
/// [anchor] is that day. It is kept when the kind changes, so going from
/// "August" to "Week" lands on a week in August, and back to "Month" returns
/// to August. Times are local calendar days: a day runs from midnight to
/// midnight on this phone.
class Period extends Equatable {
  /// [firstWeekday] is the day a week starts on (`DateTime.monday` … `sunday`),
  /// which depends on the user's language.
  factory Period(
    PeriodKind kind,
    DateTime anchor, {
    int firstWeekday = DateTime.monday,
  }) {
    final day = DateTime(anchor.year, anchor.month, anchor.day);
    final start = switch (kind) {
      PeriodKind.day => day,
      PeriodKind.week => DateTime(
        day.year,
        day.month,
        day.day - (day.weekday - firstWeekday) % DateTime.daysPerWeek,
      ),
      PeriodKind.month => DateTime(day.year, day.month),
      PeriodKind.year => DateTime(day.year),
    };
    return Period._(kind, day, start, firstWeekday);
  }

  /// The month the home screen used to show, as one [Period].
  factory Period.ofMonth(Month month) => Period(PeriodKind.month, month.start);

  const Period._(this.kind, this.anchor, this.start, this.firstWeekday);

  final PeriodKind kind;

  /// The day picked, at midnight.
  final DateTime anchor;

  /// First instant of the period.
  final DateTime start;

  final int firstWeekday;

  /// First instant after the period.
  DateTime get endExclusive => switch (kind) {
    PeriodKind.day => DateTime(start.year, start.month, start.day + 1),
    PeriodKind.week => DateTime(
      start.year,
      start.month,
      start.day + DateTime.daysPerWeek,
    ),
    PeriodKind.month => DateTime(start.year, start.month + 1),
    PeriodKind.year => DateTime(start.year + 1),
  };

  /// Its last day, at midnight.
  DateTime get lastDay =>
      DateTime(endExclusive.year, endExclusive.month, endExclusive.day - 1);

  /// The month the picked day is in. Budgets and analyses are monthly, so
  /// they follow this whatever the period.
  Month get month => Month.fromDate(anchor);

  bool contains(DateTime date) =>
      !date.isBefore(start) && date.isBefore(endExclusive);

  /// Whether nothing of it lies after [now]; the home screen does not go
  /// further than the period holding today.
  bool endsBefore(DateTime now) => !endExclusive.isAfter(now);

  /// The same kind of period [by] steps later (earlier when negative). The
  /// day of the month is kept where it exists: 31 January plus a month is
  /// the end of February.
  Period shift(int by) => at(switch (kind) {
    PeriodKind.day => DateTime(anchor.year, anchor.month, anchor.day + by),
    PeriodKind.week => DateTime(
      anchor.year,
      anchor.month,
      anchor.day + by * DateTime.daysPerWeek,
    ),
    PeriodKind.month => _clampedDay(anchor.year, anchor.month + by),
    PeriodKind.year => _clampedDay(anchor.year + by, anchor.month),
  });

  /// This period's day, seen as another kind of period.
  Period withKind(PeriodKind kind) =>
      Period(kind, anchor, firstWeekday: firstWeekday);

  /// Another day, keeping the kind.
  Period at(DateTime day) => Period(kind, day, firstWeekday: firstWeekday);

  DateTime _clampedDay(int year, int month) {
    final lastOfMonth = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, math.min(anchor.day, lastOfMonth));
  }

  @override
  List<Object?> get props => [kind, anchor, start, firstWeekday];
}
