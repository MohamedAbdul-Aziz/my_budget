import 'package:intl/intl.dart';

import '../../features/expenses/domain/entities/month.dart';

/// Every number and date format the UI needs, built once per language or
/// currency change and passed down through cubit state — so no `NumberFormat`
/// or `DateFormat` is ever constructed inside a `build()`.
class AppFormats {
  factory AppFormats({required String localeName, String? currencySymbol}) {
    // An unsupported locale falls back to en_US rather than throwing.
    final numberLocale =
        Intl.verifiedLocale(
          localeName,
          NumberFormat.localeExists,
          onFailure: (_) => 'en_US',
        ) ??
        'en_US';
    final dateLocale = _resolveDateLocale(localeName);
    final resolvedSymbol =
        currencySymbol ??
        NumberFormat.simpleCurrency(locale: numberLocale).currencySymbol;

    return AppFormats._(
      localeName: localeName,
      symbol: resolvedSymbol,
      full: NumberFormat.currency(
        locale: numberLocale,
        symbol: resolvedSymbol,
        decimalDigits: 2,
      ),
      whole: NumberFormat.currency(
        locale: numberLocale,
        symbol: resolvedSymbol,
        decimalDigits: 0,
      ),
      monthYear: DateFormat.yMMMM(dateLocale),
      dayMonth: DateFormat.MMMd(dateLocale),
      weekdayDayMonth: DateFormat.MMMEd(dateLocale),
      dayMonthYear: DateFormat.yMMMd(dateLocale),
    );
  }

  /// Null means "use intl's default locale", which is what we want both for a
  /// language we do not translate and before `initializeDateFormatting` has
  /// run — `DateFormat.localeExists` throws in that second case rather than
  /// answering false.
  static String? _resolveDateLocale(String localeName) {
    try {
      return Intl.verifiedLocale(
        localeName,
        DateFormat.localeExists,
        onFailure: (_) => null,
      );
    } on Object {
      return null;
    }
  }

  AppFormats._({
    required this.localeName,
    required this.symbol,
    required NumberFormat full,
    required NumberFormat whole,
    required DateFormat monthYear,
    required DateFormat dayMonth,
    required DateFormat weekdayDayMonth,
    required DateFormat dayMonthYear,
  }) : _full = full,
       _whole = whole,
       _monthYear = monthYear,
       _dayMonth = dayMonth,
       _weekdayDayMonth = weekdayDayMonth,
       _dayMonthYear = dayMonthYear;

  final String localeName;
  final String symbol;
  final NumberFormat _full;
  final NumberFormat _whole;
  final DateFormat _monthYear;
  final DateFormat _dayMonth;
  final DateFormat _weekdayDayMonth;
  final DateFormat _dayMonthYear;

  /// `$12.50` — always two decimals.
  String money(double amount) => _full.format(amount);

  /// Drops the cents when there are none, which keeps the big monthly total
  /// readable at a glance.
  String moneyTight(double amount) => amount == amount.roundToDouble()
      ? _whole.format(amount)
      : _full.format(amount);

  /// `August 2026`.
  String monthLabel(Month month) => _monthYear.format(month.start);

  /// `12 Aug`.
  String dayAndMonth(DateTime date) => _dayMonth.format(date);

  /// The full date, used when a day is neither today nor yesterday.
  String dayLabel(DateTime date, {DateTime? now}) {
    final today = dayOf(now ?? DateTime.now());
    return dayOf(date).year == today.year
        ? _weekdayDayMonth.format(date)
        : _dayMonthYear.format(date);
  }

  /// 0 for today, 1 for yesterday, and so on.
  static int daysAgo(DateTime date, {DateTime? now}) =>
      dayOf(now ?? DateTime.now()).difference(dayOf(date)).inDays;

  static bool isSameDay(DateTime a, DateTime b) => dayOf(a) == dayOf(b);

  static DateTime dayOf(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  bool operator ==(Object other) =>
      other is AppFormats &&
      other.localeName == localeName &&
      other.symbol == symbol;

  @override
  int get hashCode => Object.hash(localeName, symbol);
}
