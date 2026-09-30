import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/app_formats.dart';
import '../domain/entities/recurring_expense.dart';
import '../domain/entities/recurring_overview.dart';

/// How a recurring payment's standing is worded and colored, the same on
/// every screen.
extension RecurringLabels on RecurringCommitment {
  String statusLabel(AppStrings strings) => switch (status) {
    RecurringStatus.paid => strings.statusPaid,
    RecurringStatus.upcoming => strings.statusUpcoming,
    RecurringStatus.overdue => strings.statusOverdue,
  };

  /// Green once paid, red when late, orange on the day it is due. Anything
  /// further off is not worth a color.
  Color statusColor(BuildContext context) {
    final colors = StatusColors.of(context);
    return switch (status) {
      RecurringStatus.paid => colors.good,
      RecurringStatus.overdue => colors.danger,
      RecurringStatus.upcoming when isDueToday => colors.caution,
      RecurringStatus.upcoming => Theme.of(
        context,
      ).colorScheme.onSurfaceVariant,
    };
  }

  /// When the next payment is due, or since when it is late.
  String dueLabel(AppStrings strings, AppFormats formats) => switch (status) {
    RecurringStatus.paid => strings.nextDueOn(formats.dayLabel(nextDue)),
    RecurringStatus.overdue => strings.overdueSince(
      formats.dayLabel(nextDue),
      overdueCount,
    ),
    RecurringStatus.upcoming when isDueToday => strings.dueToday,
    RecurringStatus.upcoming => strings.dueOnDate(formats.dayLabel(nextDue)),
  };
}

/// "Monthly on day 15", and "· Auto-deduct" when the app logs it.
String scheduleLabel(
  AppStrings strings,
  RecurringExpense recurring,
  AppFormats formats,
) {
  final schedule = strings.recurringSchedule(
    recurring.frequency,
    dueDay: recurring.dueDay,
    dueMonth: recurring.dueMonth,
    formats: formats,
  );
  return recurring.isAutomatic ? '$schedule · ${strings.autoDeduct}' : schedule;
}
