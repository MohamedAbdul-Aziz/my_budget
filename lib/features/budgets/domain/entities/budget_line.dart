import 'package:equatable/equatable.dart';

/// How close spending is to its limit, which decides the color it is shown in.
enum BudgetLevel {
  /// Under 70% of the limit.
  safe,

  /// From 70% up to and including 90%.
  warning,

  /// Over 90%, including anything past the limit.
  critical;

  static const double warningFrom = 0.7;
  static const double criticalAbove = 0.9;

  static BudgetLevel of(double fraction) => switch (fraction) {
    > criticalAbove => critical,
    >= warningFrom => warning,
    _ => safe,
  };
}

/// Spending set against one limit: the whole month's, or one category's.
///
/// Every comparison is made in whole cents, so a float sum such as
/// 0.1 + 0.2 never tips a line over a threshold it has not really reached.
class BudgetLine extends Equatable {
  const BudgetLine({required this.spent, required this.limit});

  final double spent;

  /// Always greater than zero.
  final double limit;

  /// The share of the limit used so far: 0.5 is half, above 1 is over.
  double get fraction {
    final limitCents = _cents(limit);
    return limitCents <= 0 ? 0 : _cents(spent) / limitCents;
  }

  /// What is left before the limit; negative once it has been passed.
  double get remaining => (_cents(limit) - _cents(spent)) / 100;

  bool get isOver => _cents(spent) > _cents(limit);

  BudgetLevel get level => BudgetLevel.of(fraction);

  /// Whether [spent] (this line's own, unless given) reaches [share] of the
  /// limit.
  bool reaches(double share, {double? spent}) =>
      _cents(spent ?? this.spent) >= _cents(limit * share);

  static int _cents(double amount) => (amount * 100).round();

  @override
  List<Object?> get props => [spent, limit];
}
