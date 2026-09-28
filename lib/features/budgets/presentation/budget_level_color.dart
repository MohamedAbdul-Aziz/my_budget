import 'package:flutter/material.dart';

import '../../../core/theme/status_colors.dart';
import '../domain/entities/budget_line.dart';

/// Green while a budget is comfortable, orange from 70%, red past 90%.
extension BudgetLevelColor on BudgetLevel {
  Color colorIn(StatusColors colors) => switch (this) {
    BudgetLevel.safe => colors.good,
    BudgetLevel.warning => colors.caution,
    BudgetLevel.critical => colors.danger,
  };
}
