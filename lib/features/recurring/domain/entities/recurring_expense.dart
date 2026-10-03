import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import 'recurrence_frequency.dart';
import 'recurring_mode.dart';

/// Money that comes back on a schedule: rent, a bill, a subscription, or
/// income such as a salary. Like a transaction, it is whichever type its
/// [category] is.
///
/// Due dates are whole calendar days, a [DateTime] at local midnight. The
/// schedule is kept as a rule rather than a list of dates:
/// * monthly: [dueDay] of every month, 1 to 31. A month without that day
///   uses its last one, so the 31st falls on 30 April and 28 February.
/// * weekly: [dueDay] is the weekday, 1 (Monday) to 7 (Sunday), as in
///   [DateTime.weekday].
/// * yearly: [dueDay] of [dueMonth]. 29 February falls on the 28th in the
///   years without one.
///
/// Payments are counted from [startsOn]. Every one due up to [paidThrough]
/// is settled, whether the user confirmed it or the app logged it.
class RecurringExpense extends Equatable {
  const RecurringExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.frequency,
    required this.dueDay,
    this.dueMonth,
    required this.mode,
    required this.startsOn,
    this.paidThrough,
    required this.createdAt,
  });

  static const int maxTitleLength = 40;

  final String id;

  /// Also the note on every transaction it logs.
  final String title;
  final double amount;
  final ExpenseCategory category;
  final RecurrenceFrequency frequency;
  final int dueDay;

  /// 1 to 12, for a yearly payment only.
  final int? dueMonth;
  final RecurringMode mode;

  /// The first day a payment can fall due.
  final DateTime startsOn;

  /// The due date of the latest settled payment; null until one is.
  final DateTime? paidThrough;
  final DateTime createdAt;

  bool get isAutomatic => mode == RecurringMode.autoDeduct;

  /// Money coming in, such as a salary, rather than a payment going out.
  bool get isIncome => category.isIncome;

  /// What it costs in an average month, so different schedules add up.
  double get monthlyCost => switch (frequency) {
    RecurrenceFrequency.weekly => amount * 52 / 12,
    RecurrenceFrequency.monthly => amount,
    RecurrenceFrequency.yearly => amount / 12,
  };

  /// The first due date on or after [date].
  DateTime dueOnOrAfter(DateTime date) {
    final from = dayOf(date);
    switch (frequency) {
      case RecurrenceFrequency.weekly:
        final ahead = (dueDay - from.weekday) % 7;
        return DateTime(from.year, from.month, from.day + ahead);
      case RecurrenceFrequency.monthly:
        final due = clampedDay(from.year, from.month, dueDay);
        return due.isBefore(from)
            ? clampedDay(from.year, from.month + 1, dueDay)
            : due;
      case RecurrenceFrequency.yearly:
        final month = dueMonth ?? 1;
        final due = clampedDay(from.year, month, dueDay);
        return due.isBefore(from)
            ? clampedDay(from.year + 1, month, dueDay)
            : due;
    }
  }

  /// The oldest payment not yet settled.
  DateTime get nextDue {
    final paid = paidThrough;
    if (paid == null) return dueOnOrAfter(startsOn);
    final dayAfter = DateTime(paid.year, paid.month, paid.day + 1);
    return dueOnOrAfter(dayAfter.isAfter(startsOn) ? dayAfter : startsOn);
  }

  bool isSettled(DateTime due) {
    final paid = paidThrough;
    return paid != null && !dayOf(due).isAfter(paid);
  }

  /// Every unsettled payment due on or before [date], oldest first. Capped
  /// at [limit], so a schedule left alone for years cannot flood the ledger
  /// in one go.
  List<DateTime> unsettledThrough(DateTime date, {int limit = 120}) {
    final end = dayOf(date);
    final dues = <DateTime>[];
    var due = nextDue;
    while (!due.isAfter(end) && dues.length < limit) {
      dues.add(due);
      due = dueOnOrAfter(DateTime(due.year, due.month, due.day + 1));
    }
    return dues;
  }

  /// The payment belonging to the stretch of time [date] is in: its week
  /// for a weekly payment, its month for a monthly one, and for a yearly one
  /// its month too, when that is the month it falls due. Null when that
  /// stretch has no payment, or only one from before [startsOn].
  DateTime? dueInPeriodOf(DateTime date) {
    final day = dayOf(date);
    if (frequency == RecurrenceFrequency.yearly &&
        day.month != (dueMonth ?? 1)) {
      return null;
    }
    final due = dueInCycleOf(day);
    return due.isBefore(startsOn) ? null : due;
  }

  /// The payment in the same week, month or year as [date], whether or not
  /// it is before [startsOn].
  DateTime dueInCycleOf(DateTime date) {
    final day = dayOf(date);
    return switch (frequency) {
      RecurrenceFrequency.weekly => DateTime(
        day.year,
        day.month,
        day.day - day.weekday + dueDay,
      ),
      RecurrenceFrequency.monthly => clampedDay(day.year, day.month, dueDay),
      RecurrenceFrequency.yearly => clampedDay(day.year, dueMonth ?? 1, dueDay),
    };
  }

  RecurringExpense copyWith({
    String? title,
    double? amount,
    ExpenseCategory? category,
    RecurrenceFrequency? frequency,
    int? dueDay,
    int? Function()? dueMonth,
    RecurringMode? mode,
    DateTime? Function()? paidThrough,
  }) => RecurringExpense(
    id: id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    frequency: frequency ?? this.frequency,
    dueDay: dueDay ?? this.dueDay,
    dueMonth: dueMonth == null ? this.dueMonth : dueMonth(),
    mode: mode ?? this.mode,
    startsOn: startsOn,
    paidThrough: paidThrough == null ? this.paidThrough : paidThrough(),
    createdAt: createdAt,
  );

  /// [date] with the time of day dropped.
  static DateTime dayOf(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// [day] of [month], or the month's last day when it is shorter. [month]
  /// may run past 12 into the next year.
  static DateTime clampedDay(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day < lastDay ? day : lastDay);
  }

  /// How many days [month] can have, counting 29 February.
  static int longestMonth(int month) => DateTime(2024, month + 1, 0).day;

  @override
  List<Object?> get props => [
    id,
    title,
    amount,
    category,
    frequency,
    dueDay,
    dueMonth,
    mode,
    startsOn,
    paidThrough,
    createdAt,
  ];
}
