import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/category_label.dart';
import '../../domain/entities/category_breakdown.dart';
import '../../domain/entities/month_overview.dart';

/// The headline of the home screen: how much this month has cost so far.
class MonthTotalCard extends StatelessWidget {
  const MonthTotalCard({
    super.key,
    required this.overview,
    required this.formats,
  });

  final MonthOverview overview;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final count = overview.expenses.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.spentIn(formats.monthLabel(overview.month)),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formats.moneyTight(overview.total),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.expenseCount(count),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (overview.breakdown.isNotEmpty) ...[
              const SizedBox(height: 18),
              _BreakdownBar(breakdown: overview.breakdown),
              const SizedBox(height: 12),
              _BreakdownLegend(breakdown: overview.breakdown),
            ],
          ],
        ),
      ),
    );
  }
}

/// One proportional segment per category.
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

class _BreakdownLegend extends StatelessWidget {
  const _BreakdownLegend({required this.breakdown});

  final List<CategoryBreakdown> breakdown;

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
          Row(
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
                ),
              ),
            ],
          ),
      ],
    );
  }
}
