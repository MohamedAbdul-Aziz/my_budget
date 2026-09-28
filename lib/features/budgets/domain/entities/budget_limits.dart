import 'package:equatable/equatable.dart';

/// The spending limits the user has set.
///
/// They belong to no month in particular: the same limits apply to every
/// month until the user changes them.
class BudgetLimits extends Equatable {
  const BudgetLimits({this.monthly, this.byCategory = const {}});

  /// The cap on a whole month's spending, or null when there is none.
  final double? monthly;

  /// Caps on single categories, by category id. A category without a cap has
  /// no entry.
  final Map<String, double> byCategory;

  bool get isEmpty => monthly == null && byCategory.isEmpty;

  @override
  List<Object?> get props => [monthly, byCategory];
}
