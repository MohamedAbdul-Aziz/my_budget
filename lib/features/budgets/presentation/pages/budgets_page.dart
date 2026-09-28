import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/status_colors.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/budget_alert.dart';
import '../../domain/entities/budget_line.dart';
import '../../domain/entities/budget_status.dart';
import '../budget_level_color.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';
import '../widgets/budget_limit_dialog.dart';
import '../widgets/budget_progress_bar.dart';
import '../widgets/budget_summary.dart';

/// Every budget in one place: the monthly one first, then a limit for each
/// category, all measured against the month the home screen shows.
class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const BudgetsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const _Title()),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) => switch (state) {
          BudgetLoading() => const Center(child: CircularProgressIndicator()),
          BudgetLoadFailure(:final error) => _LoadFailure(
            message: context.strings.failure(error),
          ),
          BudgetReady(:final status) => _BudgetList(status: status),
        },
      ),
    );
  }
}

/// "Budgets · September 2026".
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    return BlocSelector<BudgetCubit, BudgetState, Month?>(
      selector: (state) => state is BudgetReady ? state.status.month : null,
      builder: (context, month) => Text(
        month == null
            ? strings.budgets
            : '${strings.budgets} · ${formats.monthLabel(month)}',
      ),
    );
  }
}

class _BudgetList extends StatelessWidget {
  const _BudgetList({required this.status});

  final BudgetStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _MonthlySection(line: status.total, formats: formats),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            strings.categoryBudgets,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            strings.categoryBudgetsHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final entry in status.categories)
                _CategoryBudgetRow(entry: entry, formats: formats),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            strings.budgetsRepeatHint(
              formats.percent(BudgetThreshold.nearing.share),
              formats.percent(BudgetThreshold.reached.share),
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthlySection extends StatelessWidget {
  const _MonthlySection({required this.line, required this.formats});

  /// Null when no monthly budget is set.
  final BudgetLine? line;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final line = this.line;

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 8, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      strings.monthlyBudget,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (line != null)
                    IconButton(
                      tooltip: strings.editBudget,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => BudgetLimitDialog.editMonthly(
                        context,
                        current: line.limit,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: line != null
                  ? BudgetSummary(line: line, formats: formats)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          strings.setBudgetHint,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.tonalIcon(
                          onPressed: () =>
                              BudgetLimitDialog.editMonthly(context),
                          icon: const Icon(Icons.savings_outlined),
                          label: Text(strings.setMonthlyBudget),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One category: its spending and, when it has a limit, how much of it is
/// used. Tapping it sets, changes or removes that limit.
class _CategoryBudgetRow extends StatelessWidget {
  const _CategoryBudgetRow({required this.entry, required this.formats});

  final CategoryBudget entry;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final line = entry.line;

    return InkWell(
      onTap: () => BudgetLimitDialog.editCategory(context, entry),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CategoryAvatar(category: entry.category, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          categoryLabel(strings, entry.category),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (line == null)
                        Text(
                          strings.setLimit,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        )
                      else
                        Text(
                          formats.percent(line.fraction),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: line.level.colorIn(StatusColors.of(context)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (line != null) ...[
                    BudgetProgressBar(line: line, height: 6),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    line == null
                        ? strings.amountSpent(formats.moneyTight(entry.spent))
                        : strings.spentOfLimit(
                            formats.moneyTight(line.spent),
                            formats.moneyTight(line.limit),
                          ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: context.read<BudgetCubit>().refresh,
              child: Text(context.strings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
