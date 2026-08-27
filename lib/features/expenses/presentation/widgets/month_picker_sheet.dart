import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../domain/entities/month.dart';
import '../../domain/entities/monthly_summary.dart';

/// Switch months. Every month with spending is listed with its total, so
/// looking back is one tap from the home screen.
class MonthPickerSheet extends StatelessWidget {
  const MonthPickerSheet({
    super.key,
    required this.months,
    required this.selected,
    required this.formats,
  });

  final List<MonthlySummary> months;
  final Month selected;
  final AppFormats formats;

  static Future<Month?> show(
    BuildContext context, {
    required List<MonthlySummary> months,
    required Month selected,
    required AppFormats formats,
  }) => showModalBottomSheet<Month>(
    context: context,
    builder: (_) => MonthPickerSheet(
      months: months,
      selected: selected,
      formats: formats,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final rows = _rows();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              strings.yourMonths,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final row = rows[index];
                final isSelected = row.month == selected;
                return ListTile(
                  selected: isSelected,
                  selectedTileColor: theme.colorScheme.primaryContainer
                      .withValues(alpha: 0.5),
                  onTap: () => Navigator.of(context).pop(row.month),
                  title: Text(
                    formats.monthLabel(row.month),
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(strings.expenseCount(row.expenseCount)),
                  trailing: Text(
                    formats.moneyTight(row.total),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// The stored months, plus the current and selected month even when they are
  /// still empty — otherwise there would be no way back to them.
  List<MonthlySummary> _rows() {
    final rows = [...months];
    for (final month in {Month.current(), selected}) {
      if (!rows.any((row) => row.month == month)) {
        rows.add(MonthlySummary(month: month, total: 0, expenseCount: 0));
      }
    }
    rows.sort((a, b) => b.month.compareTo(a.month));
    return rows;
  }
}
