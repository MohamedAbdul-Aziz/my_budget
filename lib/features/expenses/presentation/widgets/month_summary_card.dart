import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/transaction_colors.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../../categories/presentation/category_label.dart';
import '../../domain/entities/category_breakdown.dart';
import '../../domain/entities/period.dart';
import '../../domain/entities/period_overview.dart';
import '../pages/search_page.dart';

/// The headline of the home screen: what the month brought in, what it cost,
/// what is left, and how much of the income that is.
class MonthSummaryCard extends StatelessWidget {
  const MonthSummaryCard({
    super.key,
    required this.overview,
    required this.formats,
  });

  final PeriodOverview overview;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final colors = TransactionColors.of(context);
    final net = overview.net;
    // In the black reads as income, in the red as spending.
    final netColor = net < 0
        ? colors.expense
        : net > 0
        ? colors.income
        : theme.colorScheme.onSurface;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.netBalance,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      formats.moneyTight(net),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        color: netColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _SavingsRate(rate: overview.savingsRate, formats: formats),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    type: TransactionType.income,
                    label: strings.totalIncome,
                    amount: formats.moneyTight(overview.income),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Metric(
                    type: TransactionType.expense,
                    label: strings.totalExpenses,
                    amount: formats.moneyTight(overview.spent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              strings.transactionCount(overview.transactions.length),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (overview.breakdown.isNotEmpty) ...[
              const SizedBox(height: 14),
              _BreakdownBar(breakdown: overview.breakdown),
              const SizedBox(height: 12),
              _BreakdownLegend(
                breakdown: overview.breakdown,
                period: overview.period,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// `Savings rate 25%` in a pill tinted by how the month is going, or a nudge
/// to record income while there is none to measure against.
class _SavingsRate extends StatelessWidget {
  const _SavingsRate({required this.rate, required this.formats});

  /// Null without income.
  final double? rate;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final rate = this.rate;

    if (rate == null) {
      return Text(
        strings.savingsRateNoIncome,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    final colors = TransactionColors.of(context);
    final type = rate < 0 ? TransactionType.expense : TransactionType.income;
    final accent = colors.accent(type);

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.container(type),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.savings_outlined, size: 16, color: accent),
              const SizedBox(width: 6),
              Text(
                strings.savingsRate,
                style: theme.textTheme.labelMedium?.copyWith(color: accent),
              ),
              const SizedBox(width: 6),
              Text(
                formats.percent(rate),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Income or spending: an arrow in its accent, a label, and the amount.
class _Metric extends StatelessWidget {
  const _Metric({
    required this.type,
    required this.label,
    required this.amount,
  });

  final TransactionType type;
  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = TransactionColors.of(context);
    final accent = colors.accent(type);

    return MergeSemantics(
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.container(type),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Icon(
                type == TransactionType.income
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 18,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    amount,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One proportional segment per spending category.
class _BreakdownBar extends StatelessWidget {
  const _BreakdownBar({required this.breakdown});

  final List<CategoryBreakdown> breakdown;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            for (final slice in breakdown)
              Expanded(
                // Sub-percent slices still get a sliver of width.
                flex: (slice.share * 1000).round().clamp(1, 1000),
                child: ColoredBox(color: Color(slice.category.colorValue)),
              ),
          ],
        ),
      ),
    );
  }
}

/// The largest categories by name. Tapping one lists its transactions over
/// the same period, in the search.
class _BreakdownLegend extends StatelessWidget {
  const _BreakdownLegend({required this.breakdown, required this.period});

  final List<CategoryBreakdown> breakdown;
  final Period period;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    // Three is all that fits comfortably on a phone; the rest is in the list.
    final top = breakdown.take(3);

    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final slice in top)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.of(context).push(
              SearchPage.forCategory(
                slice.category.id,
                from: period.start,
                to: period.lastDay,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(slice.category.colorValue),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${categoryLabel(strings, slice.category)} · '
                    '${(slice.share * 100).round()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      decoration: TextDecoration.underline,
                      decorationColor: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
