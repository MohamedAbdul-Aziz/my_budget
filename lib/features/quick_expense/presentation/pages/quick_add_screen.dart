import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../budgets/domain/entities/budget_alert.dart';
import '../../../budgets/presentation/widgets/budget_alert_messages.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../../categories/presentation/widgets/category_picker.dart';
import '../../../expenses/presentation/cubit/expense_form_cubit.dart';
import '../../../expenses/presentation/cubit/expense_form_state.dart';
import '../../../expenses/presentation/widgets/transaction_type_toggle.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../publish_widget.dart';

/// The entire UI behind a home screen widget tap: expense or income, amount,
/// category, save.
///
/// It is the only thing the quick-add activity shows — the app's home screen
/// is never built. The category arrives already chosen from the widget, the
/// date is today and the note is skipped, so recording an expense is one
/// number and one tap; income is one more tap on the toggle. Saving redraws
/// the widget and closes the dialog, returning the user to the launcher.
class QuickAddScreen extends StatelessWidget {
  const QuickAddScreen({super.key, this.categoryId});

  /// The category the user tapped on the widget.
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    final categoriesState = sl<CategoriesCubit>().state;
    final categories = switch (categoriesState) {
      CategoriesReady(:final categories) => categories,
      _ => const <ExpenseCategory>[],
    };
    final tapped = categories.where((c) => c.id == categoryId).firstOrNull;

    return BlocProvider(
      create: (_) => sl<ExpenseFormCubit>()
        // Falls back to the first spending category, so there is always a
        // category and the amount really is the only required input.
        ..start(
          suggestedCategory:
              tapped ??
              categoriesOfType(
                categoriesState,
                TransactionType.expense,
              ).firstOrNull,
        ),
      child: const _QuickAddView(),
    );
  }
}

class _QuickAddView extends StatefulWidget {
  const _QuickAddView();

  @override
  State<_QuickAddView> createState() => _QuickAddViewState();
}

class _QuickAddViewState extends State<_QuickAddView> {
  late final TextEditingController _amountController;
  late final FocusNode _amountFocus;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountFocus = FocusNode();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  /// Quick entry never asks for a note, and the date is always today.
  void _submit() => context.read<ExpenseFormCubit>().submit(
    amountText: _amountController.text,
  );

  /// Closes the activity, which drops the user back on the home screen.
  Future<void> _close() => SystemNavigator.pop();

  Future<void> _onSaved(List<BudgetAlert> alerts) async {
    await publishQuickExpenseWidget();
    // The activity is about to close, so a budget heads-up has to be read
    // here, before it goes.
    if (alerts.isNotEmpty && mounted) {
      await BudgetAlertMessages.showAsDialog(context, alerts);
    }
    await _close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ExpenseFormCubit, ExpenseFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ExpenseFormStatus.success:
            _onSaved(state.budgetAlerts);
          case ExpenseFormStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    context.strings.failure(state.error ?? FailureCode.unknown),
                  ),
                ),
              );
          case ExpenseFormStatus.editing || ExpenseFormStatus.submitting:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Tapping away from the card cancels, like any dialog.
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                child: ColoredBox(color: Colors.black.withValues(alpha: 0.45)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              // Warm while recording an expense, green for income.
              child: ExpenseFormAccent(
                child: Material(
                  color: theme.colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Header(),
                            const SizedBox(height: 16),
                            const ExpenseFormTypeToggle(),
                            const SizedBox(height: 16),
                            _AmountField(
                              controller: _amountController,
                              focusNode: _amountFocus,
                              onSubmitted: _submit,
                            ),
                            const SizedBox(height: 20),
                            const _QuickCategoryPicker(),
                            const SizedBox(height: 20),
                            _SaveButton(onSubmit: _submit),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Names the category that was tapped, so the user can see at a glance that
/// the widget passed the right one through.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return BlocSelector<
      ExpenseFormCubit,
      ExpenseFormState,
      (TransactionType, ExpenseCategory?)
    >(
      selector: (state) => (state.type, state.category),
      builder: (context, selection) {
        final (type, category) = selection;
        return Row(
          children: [
            if (category != null) ...[
              CategoryAvatar(category: category, size: 36),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type == TransactionType.income
                        ? strings.quickIncome
                        : strings.quickExpense,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (category != null)
                    Text(
                      categoryLabel(strings, category),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: SystemNavigator.pop,
            ),
          ],
        );
      },
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = context.select<SettingsCubit, String>(
      (cubit) => cubit.state.formats.symbol,
    );

    return Row(
      children: [
        Text(
          symbol,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              LengthLimitingTextInputFormatter(12),
            ],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmitted(),
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
            decoration: InputDecoration(
              hintText: context.strings.amountHint,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintStyle: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.35,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickCategoryPicker extends StatelessWidget {
  const _QuickCategoryPicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, categoriesState) =>
          BlocSelector<
            ExpenseFormCubit,
            ExpenseFormState,
            (TransactionType, String?)
          >(
            selector: (state) => (state.type, state.category?.id),
            builder: (context, selection) {
              final (type, selectedId) = selection;
              return CategoryPicker(
                // Only the categories of the type being recorded.
                categories: categoriesOfType(categoriesState, type),
                selectedId: selectedId,
                onSelected: context.read<ExpenseFormCubit>().selectCategory,
              );
            },
          ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormCubit, ExpenseFormState, (bool, bool)>(
      selector: (state) => (state.isSubmitting, state.isIncome),
      builder: (context, flags) {
        final (isSubmitting, isIncome) = flags;
        return FilledButton.icon(
          onPressed: isSubmitting ? null : onSubmit,
          icon: isSubmitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check_rounded),
          label: Text(
            isIncome ? context.strings.addIncome : context.strings.addExpense,
          ),
        );
      },
    );
  }
}
