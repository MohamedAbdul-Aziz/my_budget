import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../../expenses/domain/entities/category_breakdown.dart';
import '../../../expenses/domain/entities/monthly_summary.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/month_analysis.dart';
import '../cubit/analyses_cubit.dart';
import '../cubit/analyses_state.dart';
import '../widgets/charts.dart';

/// Where the selected month's money went, how it compares with the months
/// before, and what a typical day cost.
class AnalysesPage extends StatelessWidget {
  const AnalysesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const _Title()),
      body: BlocBuilder<AnalysesCubit, AnalysesState>(
        builder: (context, state) => switch (state) {
          AnalysesLoading() => const Center(child: CircularProgressIndicator()),
          AnalysesFailure(:final error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                context.strings.failure(error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AnalysesReady(:final analysis) => _AnalysisView(analysis),
        },
      ),
    );
  }
}

/// "Analyses · August 2026".
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    return BlocSelector<AnalysesCubit, AnalysesState, MonthAnalysis?>(
      selector: (state) => state is AnalysesReady ? state.analysis : null,
      builder: (context, analysis) => Text(
        analysis == null
            ? strings.analyses
            : '${strings.analyses} · ${formats.monthLabel(analysis.month)}',
      ),
    );
  }
}

class _AnalysisView extends StatelessWidget {
  const _AnalysisView(this.analysis);

  final MonthAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _ComparisonCard(analysis),
        const SizedBox(height: 12),
        _DailyCard(analysis),
        const SizedBox(height: 12),
        _CategoryCard(analysis),
        const SizedBox(height: 12),
        _TrendCard(analysis.trend),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard(this.analysis);

  final MonthAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final change = analysis.change;
    // Spending less is the good direction.
    final color = change == null || change == 0
        ? theme.colorScheme.onSurfaceVariant
        : change > 0
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return _SectionCard(
      title: strings.vsLastMonth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formats.moneyTight(analysis.total),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  strings.lastMonthTotal(
                    formats.moneyTight(analysis.previousTotal),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // At most half the width, so a long "no data" message wraps
          // instead of pushing the total off the card.
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (change != null && change != 0)
                  Icon(
                    change > 0
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: color,
                  ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    change == null
                        ? strings.noComparison
                        : formats.percent(change.abs()),
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleMedium?.copyWith(color: color),
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

class _DailyCard extends StatelessWidget {
  const _DailyCard(this.analysis);

  final MonthAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final topDay = analysis.topDay;

    Widget stat(String label, String value, String? caption) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (caption != null) Text(caption, style: theme.textTheme.bodySmall),
        ],
      ),
    );

    return _SectionCard(
      title: strings.dailySpending,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          stat(
            strings.dailyAverage,
            formats.money(analysis.dailyAverage),
            null,
          ),
          stat(
            strings.topDay,
            topDay == null ? '—' : formats.moneyTight(topDay.total),
            topDay == null ? null : strings.dayLabel(topDay.date, formats),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard(this.analysis);

  final MonthAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final breakdown = analysis.breakdown;

    return _SectionCard(
      title: strings.byCategory,
      child: breakdown.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                strings.noSpendingThisMonth,
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                DonutChart(
                  slices: [
                    for (final item in breakdown)
                      (
                        value: item.total,
                        color: Color(item.category.colorValue),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                for (final item in breakdown) _CategoryRow(item),
              ],
            ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow(this.item);

  final CategoryBreakdown item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            CategoryAvatar(category: item.category, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                categoryLabel(context.strings, item.category),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // A large total in a long currency symbol scales down rather
            // than pushing past the card; figures that fit are untouched.
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.55,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formats.percent(item.share),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formats.moneyTight(item.total),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard(this.trend);

  final List<MonthlySummary> trend;

  @override
  Widget build(BuildContext context) {
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    return _SectionCard(
      title: context.strings.monthlyTrend,
      child: BarChart(
        bars: [
          for (final (index, summary) in trend.indexed)
            (
              label: formats.shortMonth(summary.month),
              value: summary.total,
              highlighted: index == trend.length - 1,
            ),
        ],
      ),
    );
  }
}
