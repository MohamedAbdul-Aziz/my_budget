import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import '../../../expenses/domain/entities/month.dart';

/// The raw numbers behind the home screen widget, before any formatting.
class QuickExpenseData extends Equatable {
  const QuickExpenseData({
    required this.month,
    required this.monthTotal,
    required this.categories,
  });

  final Month month;
  final double monthTotal;

  /// The shortcuts to show, most useful first.
  final List<ExpenseCategory> categories;

  @override
  List<Object?> get props => [month, monthTotal, categories];
}
