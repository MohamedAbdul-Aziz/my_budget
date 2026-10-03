import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/status_colors.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/budget_alert.dart';
import '../../domain/entities/budget_line.dart';
import '../budget_level_color.dart';

/// What the user is told when an expense pushes a budget past a threshold,
/// in the color that budget's bar has now turned.
abstract final class BudgetAlertMessages {
  /// One sentence, such as "You've used 85% of your monthly budget".
  static String text(
    AppStrings strings,
    AppFormats formats,
    BudgetAlert alert,
  ) {
    final line = alert.line;
    final category = alert.category;
    final name = category == null ? null : categoryLabel(strings, category);
    final percent = formats.percent(line.fraction);
    final over = formats.moneyTight(-line.remaining);

    return switch ((alert.threshold, name)) {
      (BudgetThreshold.nearing, null) => strings.monthlyBudgetNearing(percent),
      (BudgetThreshold.nearing, final name?) => strings.categoryBudgetNearing(
        name,
        percent,
      ),
      (BudgetThreshold.reached, null) when line.isOver =>
        strings.monthlyBudgetExceeded(over),
      (BudgetThreshold.reached, null) => strings.monthlyBudgetUsedUp,
      (BudgetThreshold.reached, final name?) when line.isOver =>
        strings.categoryBudgetExceeded(name, over),
      (BudgetThreshold.reached, final name?) => strings.categoryBudgetUsedUp(
        name,
      ),
    };
  }

  /// A snackbar, for the main app: it stays on screen while the expense form
  /// closes. [onView] adds a button that opens the budgets.
  static void showAsSnackBar(
    BuildContext context,
    List<BudgetAlert> alerts, {
    VoidCallback? onView,
  }) {
    final strings = context.strings;
    final level = _levelOf(alerts);
    final background = level.colorIn(StatusColors.of(context));
    final foreground =
        ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          // Longer than a routine notice: this one is worth reading.
          duration: const Duration(seconds: 6),
          content: _AlertContent(
            icon: _iconFor(level),
            color: foreground,
            lines: _textsOf(context, alerts),
          ),
          action: onView == null
              ? null
              : SnackBarAction(
                  label: strings.view,
                  textColor: foreground,
                  onPressed: onView,
                ),
        ),
      );
  }

  /// A dialog, for the quick-add screen: it closes as soon as the expense is
  /// saved, which leaves no screen for a snackbar to stay on.
  static Future<void> showAsDialog(
    BuildContext context,
    List<BudgetAlert> alerts,
  ) {
    final strings = context.strings;
    final level = _levelOf(alerts);
    final lines = _textsOf(context, alerts);

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          _iconFor(level),
          color: level.colorIn(StatusColors.of(context)),
        ),
        title: Text(strings.budgetAlertTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(line, textAlign: TextAlign.center),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  static List<String> _textsOf(BuildContext context, List<BudgetAlert> alerts) {
    final strings = context.strings;
    final formats = context.read<SettingsCubit>().state.formats;
    return [for (final alert in alerts) text(strings, formats, alert)];
  }

  /// The most pressing level among [alerts], which is the color the worst
  /// of their bars has turned.
  static BudgetLevel _levelOf(List<BudgetAlert> alerts) => alerts
      .map((alert) => alert.line.level)
      .reduce((a, b) => a.index >= b.index ? a : b);

  static IconData _iconFor(BudgetLevel level) => level == BudgetLevel.critical
      ? Icons.error_outline_rounded
      : Icons.warning_amber_rounded;
}

class _AlertContent extends StatelessWidget {
  const _AlertContent({
    required this.icon,
    required this.color,
    required this.lines,
  });

  final IconData icon;
  final Color color;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final line in lines)
                Text(
                  line,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
