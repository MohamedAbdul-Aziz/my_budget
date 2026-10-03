import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/status_colors.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/budget_line.dart';
import '../../domain/entities/budget_status.dart';
import '../budget_level_color.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';
import '../pages/budgets_page.dart';
import 'budget_limit_dialog.dart';
import 'budget_summary.dart';

/// The home screen's budget at a glance: what is left of the month's budget
/// and any category close to its own limit, or an invitation to set one.
///
/// Tapping the card opens every budget; its button edits the monthly budget
/// straight away.
class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetCubit, BudgetState>(
      builder: (context, state) => switch (state) {
        BudgetReady(:final status) => _BudgetCardBody(status: status),
        // The home screen works without budgets, so a card that cannot load
        // stays out of the way instead of showing an error.
        BudgetLoading() || BudgetLoadFailure() => const SizedBox.shrink(),
      },
    );
  }
}

class _BudgetCardBody extends StatelessWidget {
  const _BudgetCardBody({required this.status});

  final BudgetStatus status;

  @override
  Widget build(BuildContext context) {
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final total = status.total;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(BudgetsPage.route()),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 8, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (total == null)
                const _SetBudgetPrompt()
              else
                _MonthlyBudget(line: total, formats: formats),
              if (status.watchList.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 16, end: 12),
                  child: _WatchList(
                    entries: status.watchList,
                    formats: formats,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyBudget extends StatelessWidget {
  const _MonthlyBudget({required this.line, required this.formats});

  final BudgetLine line;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                strings.monthlyBudget,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            IconButton(
              tooltip: strings.editBudget,
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () =>
                  BudgetLimitDialog.editMonthly(context, current: line.limit),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: BudgetSummary(line: line, formats: formats),
        ),
      ],
    );
  }
}

class _SetBudgetPrompt extends StatelessWidget {
  const _SetBudgetPrompt();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 14, end: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.savings_outlined,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.setMonthlyBudget,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  strings.setBudgetHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            // The theme's full-width button would not fit beside the text.
            style: FilledButton.styleFrom(minimumSize: const Size(64, 40)),
            onPressed: () => BudgetLimitDialog.editMonthly(context),
            child: Text(strings.setBudget),
          ),
        ],
      ),
    );
  }
}

/// Categories at 70% of their limit or more, the furthest through first.
class _WatchList extends StatelessWidget {
  const _WatchList({required this.entries, required this.formats});

  final List<CategoryBudget> entries;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.closeToLimit,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in entries)
              _WatchChip(entry: entry, formats: formats),
          ],
        ),
      ],
    );
  }
}

class _WatchChip extends StatelessWidget {
  const _WatchChip({required this.entry, required this.formats});

  final CategoryBudget entry;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = entry.line!;
    final color = line.level.colorIn(StatusColors.of(context));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              categoryLabel(context.strings, entry.category),
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(width: 6),
            Text(
              formats.percent(line.fraction),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
