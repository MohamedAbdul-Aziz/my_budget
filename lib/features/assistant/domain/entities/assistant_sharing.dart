import 'package:equatable/equatable.dart';

import '../../../expenses/domain/entities/month.dart';

/// The stretch of time the assistant is told about.
enum AssistantRange {
  thisMonth('this_month'),
  last3Months('last_3_months'),
  last6Months('last_6_months'),
  thisYear('this_year'),

  /// From [AssistantSharing.customStart] to [AssistantSharing.customEnd].
  custom('custom');

  const AssistantRange(this.storageKey);

  /// Stored on the phone, so never renamed.
  final String storageKey;

  static AssistantRange fromStorageKey(String? key) => values.firstWhere(
    (range) => range.storageKey == key,
    orElse: () => AssistantSharing.defaults.range,
  );
}

/// The days and months a range covers on a given day.
class ResolvedRange extends Equatable {
  const ResolvedRange({
    required this.start,
    required this.endExclusive,
    required this.months,
  });

  /// First day, at midnight.
  final DateTime start;

  /// The day after the last one, at midnight.
  final DateTime endExclusive;

  /// The calendar months it touches, newest first.
  final List<Month> months;

  DateTime get lastDay =>
      DateTime(endExclusive.year, endExclusive.month, endExclusive.day - 1);

  @override
  List<Object?> get props => [start, endExclusive, months];
}

/// What the user lets the assistant see with each question. The totals
/// summary always goes; everything else is off until the user turns it on.
/// Kept on this phone only.
class AssistantSharing extends Equatable {
  const AssistantSharing({
    this.range = AssistantRange.last3Months,
    this.customStart,
    this.customEnd,
    this.transactions = false,
    this.descriptions = false,
    this.recurring = false,
    this.people = false,
  });

  /// Only the summary of the last three months: what every question sends
  /// until the user chooses otherwise.
  static const AssistantSharing defaults = AssistantSharing();

  /// The most months a summary covers, however long the range.
  static const int maxMonths = 12;

  final AssistantRange range;

  /// The chosen days for [AssistantRange.custom], at midnight.
  final DateTime? customStart;
  final DateTime? customEnd;

  /// Each transaction on its own: amount, category, date.
  final bool transactions;

  /// The notes typed with transactions. Only sent with [transactions].
  final bool descriptions;

  /// Recurring payments and income, and where each stands.
  final bool recurring;

  /// People by name, and who owes whom.
  final bool people;

  bool get isDefault => this == defaults;

  /// Notes travel only inside transactions.
  bool get sendsDescriptions => transactions && descriptions;

  /// The range on [now]'s day. A custom range without both days, or with
  /// them the wrong way round, falls back to the default.
  ResolvedRange resolve(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final current = Month.fromDate(today);
    final tomorrow = DateTime(today.year, today.month, today.day + 1);

    ResolvedRange lastMonths(int count) {
      final months = [current];
      while (months.length < count) {
        months.add(months.last.previous);
      }
      return ResolvedRange(
        start: months.last.start,
        endExclusive: tomorrow,
        months: months,
      );
    }

    switch (range) {
      case AssistantRange.thisMonth:
        return lastMonths(1);
      case AssistantRange.last3Months:
        return lastMonths(3);
      case AssistantRange.last6Months:
        return lastMonths(6);
      case AssistantRange.thisYear:
        return lastMonths(current.month);
      case AssistantRange.custom:
        final from = customStart;
        final to = customEnd;
        if (from == null || to == null || to.isBefore(from)) {
          return defaults.resolve(now);
        }
        final start = DateTime(from.year, from.month, from.day);
        final end = DateTime(to.year, to.month, to.day + 1);
        final months = <Month>[];
        var month = Month.fromDate(DateTime(end.year, end.month, end.day - 1));
        final first = Month.fromDate(start);
        while (month.compareTo(first) >= 0 && months.length < maxMonths) {
          months.add(month);
          month = month.previous;
        }
        return ResolvedRange(start: start, endExclusive: end, months: months);
    }
  }

  AssistantSharing copyWith({
    AssistantRange? range,
    DateTime? customStart,
    DateTime? customEnd,
    bool? transactions,
    bool? descriptions,
    bool? recurring,
    bool? people,
  }) => AssistantSharing(
    range: range ?? this.range,
    customStart: customStart ?? this.customStart,
    customEnd: customEnd ?? this.customEnd,
    transactions: transactions ?? this.transactions,
    descriptions: descriptions ?? this.descriptions,
    recurring: recurring ?? this.recurring,
    people: people ?? this.people,
  );

  @override
  List<Object?> get props => [
    range,
    customStart,
    customEnd,
    transactions,
    descriptions,
    recurring,
    people,
  ];
}
