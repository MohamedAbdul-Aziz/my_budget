import 'package:equatable/equatable.dart';

/// A calendar month — the unit the whole app is organised around.
class Month extends Equatable implements Comparable<Month> {
  const Month(this.year, this.month);

  factory Month.fromDate(DateTime date) => Month(date.year, date.month);

  factory Month.current() => Month.fromDate(DateTime.now());

  /// Parses the `yyyy-MM` form used as the storage key.
  factory Month.fromKey(String key) {
    final parts = key.split('-');
    if (parts.length != 2) {
      throw FormatException('Invalid month key', key);
    }
    return Month(int.parse(parts[0]), int.parse(parts[1]));
  }

  final int year;

  /// 1-12.
  final int month;

  /// Stable sortable key persisted alongside every expense.
  String get key => '$year-${month.toString().padLeft(2, '0')}';

  /// First instant of the month.
  DateTime get start => DateTime(year, month);

  /// First instant of the following month.
  DateTime get endExclusive => DateTime(year, month + 1);

  Month get previous => month == 1 ? Month(year - 1, 12) : Month(year, month - 1);

  Month get next => month == 12 ? Month(year + 1, 1) : Month(year, month + 1);

  bool get isCurrent => this == Month.current();

  bool contains(DateTime date) => date.year == year && date.month == month;

  @override
  int compareTo(Month other) {
    final byYear = year.compareTo(other.year);
    return byYear != 0 ? byYear : month.compareTo(other.month);
  }

  @override
  List<Object?> get props => [year, month];

  @override
  String toString() => key;
}
