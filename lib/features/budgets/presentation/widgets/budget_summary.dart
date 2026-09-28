import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/status_colors.dart';
import '../../../../core/utils/app_formats.dart';
import '../../domain/entities/budget_line.dart';
import '../budget_level_color.dart';
import 'budget_progress_bar.dart';

/// One budget in full: what is left of it (or how far over it is), the bar,
/// and how much of the limit was spent.
class BudgetSummary extends StatelessWidget {
  const BudgetSummary({super.key, required this.line, required this.formats});

  final BudgetLine line;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final colors = StatusColors.of(context);
    final percent = formats.percent(line.fraction);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            line.isOver
                ? strings.amountOver(formats.moneyTight(-line.remaining))
                : strings.amountLeft(formats.moneyTight(line.remaining)),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: line.isOver ? colors.danger : null,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Semantics(
          label: strings.budgetUsed(percent),
          child: BudgetProgressBar(line: line),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                strings.spentOfLimit(
                  formats.moneyTight(line.spent),
                  formats.moneyTight(line.limit),
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              percent,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: line.level.colorIn(colors),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
