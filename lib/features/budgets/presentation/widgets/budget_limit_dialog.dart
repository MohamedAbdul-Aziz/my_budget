import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/budget_status.dart';
import '../cubit/budget_cubit.dart';

/// Asks for one budget's limit.
///
/// The value is checked where it is saved. A refused one keeps the dialog
/// open with the reason under the field, so nothing typed is lost.
class BudgetLimitDialog extends StatefulWidget {
  const BudgetLimitDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.current,
    this.onRemove,
  });

  final String title;

  /// The limit being changed; null when there is none yet.
  final double? current;

  /// Returns why the typed amount was refused, or null once it is saved.
  final Future<FailureCode?> Function(String amountText) onSave;

  /// Offered only when there is a limit to remove.
  final Future<FailureCode?> Function()? onRemove;

  static Future<void> editMonthly(BuildContext context, {double? current}) {
    final cubit = context.read<BudgetCubit>();
    return showDialog<void>(
      context: context,
      builder: (context) => BudgetLimitDialog(
        title: context.strings.monthlyBudget,
        current: current,
        onSave: cubit.setMonthlyLimit,
        onRemove: current == null ? null : cubit.removeMonthlyLimit,
      ),
    );
  }

  static Future<void> editCategory(BuildContext context, CategoryBudget entry) {
    final cubit = context.read<BudgetCubit>();
    final id = entry.category.id;
    return showDialog<void>(
      context: context,
      builder: (context) => BudgetLimitDialog(
        title: context.strings.categoryBudgetTitle(
          categoryLabel(context.strings, entry.category),
        ),
        current: entry.limit,
        onSave: (amountText) => cubit.setCategoryLimit(id, amountText),
        onRemove: entry.limit == null
            ? null
            : () => cubit.removeCategoryLimit(id),
      ),
    );
  }

  @override
  State<BudgetLimitDialog> createState() => _BudgetLimitDialogState();
}

class _BudgetLimitDialogState extends State<BudgetLimitDialog> {
  late final TextEditingController _controller;

  // Local UI state: a save in flight, and why the last one was refused.
  bool _saving = false;
  FailureCode? _error;

  @override
  void initState() {
    super.initState();
    final current = widget.current;
    _controller = TextEditingController(
      text: current == null ? '' : AmountInput.editable(current),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => _run(() => widget.onSave(_controller.text));

  Future<void> _run(Future<FailureCode?> Function() action) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final error = await action();
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _saving = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final symbol = context.select<SettingsCubit, String>(
      (cubit) => cubit.state.formats.symbol,
    );
    final error = _error;
    final onRemove = widget.onRemove;

    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: AmountInput.formatters,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          prefixText: '$symbol ',
          hintText: strings.amountHint,
          errorText: error == null ? null : strings.failure(error),
          errorMaxLines: 2,
        ),
      ),
      actions: [
        if (onRemove != null)
          TextButton(
            onPressed: _saving ? null : () => _run(onRemove),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(strings.removeBudget),
          ),
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
        TextButton(
          onPressed: _saving ? null : _save,
          child: Text(strings.save),
        ),
      ],
    );
  }
}
