import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/entities/period.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'month_picker_sheet.dart';

/// The top of the home screen: whether it shows a day, a week, a month or a
/// year, and which one. The arrows step back and forth (never past today);
/// tapping the date opens a calendar, the month list or the years.
class PeriodBar extends StatelessWidget {
  const PeriodBar({super.key});

  /// When weeks start for the user's language, as `DateTime.weekday`.
  static int firstWeekdayOf(BuildContext context) {
    final index = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    return index == 0 ? DateTime.sunday : index;
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return BlocSelector<HomeCubit, HomeState, (Period, List<MonthlySummary>)?>(
      selector: (state) => switch (state) {
        HomeReady(:final period, :final months) => (period, months),
        _ => null,
      },
      builder: (context, selection) {
        if (selection == null) return const SizedBox.shrink();
        final (period, months) = selection;
        final cubit = context.read<HomeCubit>();
        final canGoNext = period.endsBefore(DateTime.now());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<PeriodKind>(
              showSelectedIcon: false,
              // Compact: the home screen's totals should stay in view.
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              segments: [
                for (final kind in PeriodKind.values)
                  ButtonSegment(
                    value: kind,
                    label: Text(_kindLabel(strings, kind)),
                  ),
              ],
              selected: {period.kind},
              onSelectionChanged: (selected) => cubit.selectKind(
                selected.single,
                firstWeekday: firstWeekdayOf(context),
              ),
            ),
            Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: strings.previousPeriod,
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => cubit.shift(-1),
                ),
                Expanded(
                  child: TextButton.icon(
                    key: const Key('period_label'),
                    onPressed: () => _pick(context, period, months, formats),
                    icon: const Icon(Icons.calendar_month_outlined, size: 20),
                    label: Text(
                      label(strings, formats, period),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: strings.nextPeriod,
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: canGoNext ? () => cubit.shift(1) : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static String _kindLabel(AppStrings strings, PeriodKind kind) =>
      switch (kind) {
        PeriodKind.day => strings.periodDay,
        PeriodKind.week => strings.periodWeek,
        PeriodKind.month => strings.periodMonth,
        PeriodKind.year => strings.periodYear,
      };

  /// "Today", "5 Oct – 11 Oct", "October 2026", "2026".
  static String label(AppStrings strings, AppFormats formats, Period period) =>
      switch (period.kind) {
        PeriodKind.day => strings.dayLabel(period.start, formats),
        PeriodKind.week =>
          '${formats.dayAndMonth(period.start)} – '
              '${formats.dayAndMonth(period.lastDay)}',
        PeriodKind.month => formats.monthLabel(period.month),
        PeriodKind.year => formats.yearLabel(period.start.year),
      };

  Future<void> _pick(
    BuildContext context,
    Period period,
    List<MonthlySummary> months,
    AppFormats formats,
  ) async {
    final cubit = context.read<HomeCubit>();
    final today = DateTime.now();
    switch (period.kind) {
      case PeriodKind.day || PeriodKind.week:
        final picked = await showDatePicker(
          context: context,
          initialDate: period.anchor,
          firstDate: DateTime(today.year - 20),
          lastDate: today,
        );
        if (picked != null) await cubit.selectDay(picked);
      case PeriodKind.month:
        final picked = await MonthPickerSheet.show(
          context,
          months: months,
          selected: period.month,
          formats: formats,
        );
        if (picked != null) await cubit.selectMonth(picked);
      case PeriodKind.year:
        final year = await showDialog<int>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            content: SizedBox(
              width: 300,
              height: 320,
              child: YearPicker(
                firstDate: DateTime(today.year - 20),
                lastDate: today,
                selectedDate: period.start,
                onChanged: (picked) =>
                    Navigator.of(dialogContext).pop(picked.year),
              ),
            ),
          ),
        );
        if (year != null) {
          // The same day in that year, so budgets follow the same month.
          final lastOfMonth = DateTime(year, period.anchor.month + 1, 0).day;
          await cubit.selectDay(
            DateTime(
              year,
              period.anchor.month,
              math.min(period.anchor.day, lastOfMonth),
            ),
          );
        }
    }
  }
}
