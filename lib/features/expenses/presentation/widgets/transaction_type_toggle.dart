import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/transaction_colors.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../cubit/expense_form_cubit.dart';
import '../cubit/expense_form_state.dart';

/// The categories of one [type], in the user's order.
List<ExpenseCategory> categoriesOfType(
  CategoriesState state,
  TransactionType type,
) => switch (state) {
  CategoriesReady(:final categories) => [
    for (final category in categories)
      if (category.type == type) category,
  ],
  _ => const [],
};

/// Re-themes [child] in the accent of [type], fading between the two when it
/// changes: buttons, the text cursor and anything else drawn in the primary
/// color turn warm for an expense and green for income.
class TransactionAccent extends StatelessWidget {
  const TransactionAccent({super.key, required this.type, required this.child});

  final TransactionType type;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final colors = TransactionColors.of(context);
    final accent = colors.accent(type);

    return AnimatedTheme(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      data: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: accent,
          onPrimary: colors.onAccent(type),
          primaryContainer: colors.container(type),
          onPrimaryContainer: accent,
        ),
        textSelectionTheme: base.textSelectionTheme.copyWith(
          cursorColor: accent,
          selectionHandleColor: accent,
          selectionColor: accent.withValues(alpha: 0.3),
        ),
      ),
      child: child,
    );
  }
}

/// [TransactionAccent] following the expense form's current type.
class ExpenseFormAccent extends StatelessWidget {
  const ExpenseFormAccent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocSelector<ExpenseFormCubit, ExpenseFormState, TransactionType>(
        selector: (state) => state.type,
        builder: (context, type) => TransactionAccent(type: type, child: child),
      );
}

/// Expense or income, side by side, the selected one filled in its accent.
class TransactionTypeToggle extends StatelessWidget {
  const TransactionTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = TransactionColors.of(context);
    final strings = context.strings;

    Color? selectedOr(
      Set<WidgetState> states,
      Color selectedColor,
      Color? other,
    ) => states.contains(WidgetState.selected) ? selectedColor : other;

    return Semantics(
      label: strings.transactionType,
      container: true,
      child: SegmentedButton<TransactionType>(
        segments: [
          ButtonSegment(
            value: TransactionType.expense,
            icon: const Icon(Icons.trending_down_rounded),
            label: Text(strings.expense),
          ),
          ButtonSegment(
            value: TransactionType.income,
            icon: const Icon(Icons.trending_up_rounded),
            label: Text(strings.income),
          ),
        ],
        selected: {selected},
        showSelectedIcon: false,
        expandedInsets: EdgeInsets.zero,
        onSelectionChanged: (types) => onChanged(types.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.standard,
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => selectedOr(states, colors.container(selected), null),
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => selectedOr(
              states,
              colors.accent(selected),
              theme.colorScheme.onSurfaceVariant,
            ),
          ),
          iconColor: WidgetStateProperty.resolveWith(
            (states) => selectedOr(
              states,
              colors.accent(selected),
              theme.colorScheme.onSurfaceVariant,
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

/// [TransactionTypeToggle] wired to the expense form. Switching suggests the
/// first category of the new type, unless one was already picked for it.
class ExpenseFormTypeToggle extends StatelessWidget {
  const ExpenseFormTypeToggle({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<ExpenseFormCubit, ExpenseFormState, TransactionType>(
        selector: (state) => state.type,
        builder: (context, type) => TransactionTypeToggle(
          selected: type,
          onChanged: (type) => context.read<ExpenseFormCubit>().selectType(
            type,
            suggestedCategory: categoriesOfType(
              context.read<CategoriesCubit>().state,
              type,
            ).firstOrNull,
          ),
        ),
      );
}
