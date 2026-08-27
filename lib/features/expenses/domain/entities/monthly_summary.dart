import 'package:equatable/equatable.dart';

import 'month.dart';

/// Aggregate row used by the month picker: one entry per month that has data.
class MonthlySummary extends Equatable {
  const MonthlySummary({
    required this.month,
    required this.total,
    required this.expenseCount,
  });

  final Month month;
  final double total;
  final int expenseCount;

  @override
  List<Object?> get props => [month, total, expenseCount];
}
