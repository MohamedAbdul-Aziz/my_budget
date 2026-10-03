import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../budgets/domain/entities/budget_status.dart';
import '../../../budgets/presentation/cubit/budget_cubit.dart';
import '../../../budgets/presentation/cubit/budget_state.dart';
import '../../../budgets/presentation/widgets/budget_progress_bar.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/analysis_question.dart';
import '../../domain/entities/month_analysis.dart';
import '../../domain/entities/month_comparison.dart';
import '../cubit/compare_months_cubit.dart';
import '../cubit/compare_months_state.dart';
import 'ask_answers.dart';
import 'charts.dart';
import 'section_card.dart';

/// Ready-made questions about the month, answered on the phone from the
/// figures the page already has: a quick way in for people who would rather
/// ask than read charts.
class AskCard extends StatefulWidget {
  const AskCard(this.analysis, {super.key});

  final MonthAnalysis analysis;

  @override
  State<AskCard> createState() => _AskCardState();
}

class _AskCardState extends State<AskCard> {
  AnalysisQuestion? _selected;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    final selected = _selected;

    return SectionCard(
      title: strings.askTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // One scrolling row, so the questions take a single line and the
          // charts below stay in view.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final question in AnalysisQuestion.values)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(_label(strings, question)),
                      selected: question == selected,
                      onSelected: (on) =>
                          setState(() => _selected = on ? question : null),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: AlignmentDirectional.topStart,
            child: selected == null
                ? Text(
                    strings.askHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : _Answer(
                    key: ValueKey(selected),
                    question: selected,
                    analysis: widget.analysis,
                  ),
          ),
        ],
      ),
    );
  }

  static String _label(AppStrings strings, AnalysisQuestion question) =>
      switch (question) {
        AnalysisQuestion.compareMonths => strings.askCompareMonths,
        AnalysisQuestion.topCategory => strings.askTopCategory,
        AnalysisQuestion.vsLastMonth => strings.askVsLastMonth,
        AnalysisQuestion.biggestExpense => strings.askBiggestExpense,
        AnalysisQuestion.topDay => strings.askTopDay,
        AnalysisQuestion.weekday => strings.askWeekday,
        AnalysisQuestion.monthEnd => strings.askMonthEnd,
        AnalysisQuestion.saved => strings.askSaved,
        AnalysisQuestion.budgetLeft => strings.askBudgetLeft,
        AnalysisQuestion.highestLowest => strings.askHighestLowest,
        AnalysisQuestion.count => strings.askCount,
        AnalysisQuestion.topIncome => strings.askTopIncome,
      };
}

class _Answer extends StatelessWidget {
  const _Answer({super.key, required this.question, required this.analysis});

  final AnalysisQuestion question;
  final MonthAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return switch (question) {
      AnalysisQuestion.compareMonths => BlocProvider(
        create: (_) => sl<CompareMonthsCubit>()..load(analysis.month),
        child: _CompareAnswer(analysis),
      ),
      AnalysisQuestion.budgetLeft => _BudgetAnswer(analysis.month),
      _ => _Lines(
        answerFor(question, analysis, strings, formats),
        chart: _chartFor(context, formats),
      ),
    };
  }

  Widget? _chartFor(BuildContext context, AppFormats formats) {
    switch (question) {
      case AnalysisQuestion.topCategory when analysis.breakdown.isNotEmpty:
        return DonutChart(
          size: 120,
          slices: [
            for (final item in analysis.breakdown)
              (value: item.total, color: Color(item.category.colorValue)),
          ],
        );
      case AnalysisQuestion.weekday when analysis.busiestWeekday != null:
        final busiest = analysis.busiestWeekday! + 1;
        // Weeks start where the reader's calendar starts them.
        // Sunday is 0 there and 7 in DateTime.weekday.
        final first = MaterialLocalizations.of(context).firstDayOfWeekIndex;
        final days = [
          for (var i = 0; i < DateTime.daysPerWeek; i++)
            (first + i - 1) % DateTime.daysPerWeek + 1,
        ];
        return BarChart(
          height: 110,
          bars: [
            for (final day in days)
              (
                label: formats.shortWeekdayName(day),
                value: analysis.byWeekday[day - 1],
                highlighted: day == busiest,
              ),
          ],
        );
      case AnalysisQuestion.highestLowest
          when analysis.highestAndLowest != null:
        final (high, _) = analysis.highestAndLowest!;
        return BarChart(
          height: 110,
          bars: [
            for (final summary in analysis.trend)
              (
                label: formats.shortMonth(summary.month),
                value: summary.total,
                highlighted: summary.month == high.month,
              ),
          ],
        );
      default:
        return null;
    }
  }
}

/// The answer's sentences, with an optional chart under them.
class _Lines extends StatelessWidget {
  const _Lines(this.lines, {this.chart});

  final List<String> lines;
  final Widget? chart;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    final chart = this.chart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(line, style: style),
          ),
        if (chart != null) ...[
          const SizedBox(height: 12),
          Center(child: chart),
        ],
      ],
    );
  }
}

class _BudgetAnswer extends StatelessWidget {
  const _BudgetAnswer(this.month);

  final Month month;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    return BlocSelector<BudgetCubit, BudgetState, BudgetStatus?>(
      selector: (state) => switch (state) {
        BudgetReady(:final status) when status.month == month => status,
        _ => null,
      },
      builder: (context, status) {
        if (status == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final total = status.total;
        return _Lines(
          budgetAnswer(status, strings, formats),
          chart: total == null ? null : BudgetProgressBar(line: total),
        );
      },
    );
  }
}

class _CompareAnswer extends StatefulWidget {
  const _CompareAnswer(this.analysis);

  final MonthAnalysis analysis;

  @override
  State<_CompareAnswer> createState() => _CompareAnswerState();
}

class _CompareAnswerState extends State<_CompareAnswer> {
  /// Follows the page: a new month or a newly logged expense redoes the
  /// comparison, keeping the month the user picked.
  @override
  void didUpdateWidget(_CompareAnswer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.analysis != widget.analysis) {
      context.read<CompareMonthsCubit>().load(widget.analysis.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return BlocBuilder<CompareMonthsCubit, CompareMonthsState>(
      builder: (context, state) => switch (state) {
        CompareMonthsLoading() => const Padding(
          padding: EdgeInsets.all(12),
          child: Center(child: CircularProgressIndicator()),
        ),
        CompareMonthsFailure(:final error) => Text(strings.failure(error)),
        CompareMonthsReady(:final comparison, :final choices) => _Comparison(
          comparison: comparison,
          choices: choices,
        ),
      },
    );
  }
}

class _Comparison extends StatelessWidget {
  const _Comparison({required this.comparison, required this.choices});

  final MonthComparison comparison;
  final List<Month> choices;

  /// Bars beyond this are added up into one "Others" pair so each bar stays
  /// wide enough to read on a phone.
  static const int _maxPairs = 5;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final rows = comparison.rows;
    final shown = rows.take(_maxPairs).toList();
    final rest = rows.skip(_maxPairs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                strings.compareWith,
                style: theme.textTheme.labelLarge,
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<Month>(
              value: comparison.second,
              onChanged: (month) {
                if (month == null) return;
                context.read<CompareMonthsCubit>().load(
                  comparison.first,
                  other: month,
                );
              },
              items: [
                for (final month in choices)
                  DropdownMenuItem(
                    value: month,
                    child: Text(formats.monthLabel(month)),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        _Lines(compareAnswer(comparison, strings, formats)),
        if (!comparison.isEmpty) ...[
          const SizedBox(height: 12),
          GroupedBarChart(
            legend: (
              '${formats.monthLabel(comparison.first)}: '
                  '${formats.moneyTight(comparison.firstTotal)}',
              '${formats.monthLabel(comparison.second)}: '
                  '${formats.moneyTight(comparison.secondTotal)}',
            ),
            pairs: [
              for (final row in shown)
                (
                  label: CategoryAvatar(category: row.category, size: 26),
                  first: row.first,
                  second: row.second,
                ),
              if (rest.isNotEmpty)
                (
                  label: Tooltip(
                    message: strings.otherCategories,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.more_horiz_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  first: rest.fold(0.0, (sum, row) => sum + row.first),
                  second: rest.fold(0.0, (sum, row) => sum + row.second),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
