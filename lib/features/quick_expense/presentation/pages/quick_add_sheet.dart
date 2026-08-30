import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../../../categories/presentation/widgets/category_picker.dart';
import '../../../expenses/presentation/cubit/expense_form_cubit.dart';
import '../../../expenses/presentation/cubit/expense_form_state.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

/// The fastest way to record an expense: amount, category, save.
///
/// This is what the Android home screen widget opens. Android widgets cannot
/// host a text field, so the widget carries the category choice and this sheet
/// collects the one thing it cannot — the amount. It opens with the keyboard
/// up and a category already selected, so saving is: type a number, tap Save.
class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  /// Resolves [categoryId] against the loaded categories and opens the sheet.
  /// Returns true when an expense was saved.
  static Future<bool?> show(BuildContext context, {String? categoryId}) {
    final categories = switch (sl<CategoriesCubit>().state) {
      CategoriesReady(:final categories) => categories,
      _ => const <ExpenseCategory>[],
    };
    final selected = categories.where((c) => c.id == categoryId).firstOrNull;

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => sl<ExpenseFormCubit>()
          ..start(
            // Falls back to the first shortcut so there is always a category.
            suggestedCategory: selected ?? categories.firstOrNull,
          ),
        child: const QuickAddSheet(),
      ),
    );
  }

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
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

  // Quick entry never asks for a note; the date is always today.
  void _submit() =>
      context.read<ExpenseFormCubit>().submit(amountText: _amountController.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return BlocListener<ExpenseFormCubit, ExpenseFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ExpenseFormStatus.success:
            Navigator.of(context).pop(true);
          case ExpenseFormStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    strings.failure(state.error ?? FailureCode.unknown),
                  ),
                ),
              );
          case ExpenseFormStatus.editing || ExpenseFormStatus.submitting:
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.quickExpense,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
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
            color: theme.colorScheme.onSurfaceVariant,
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
      builder: (context, categoriesState) {
        final categories = switch (categoriesState) {
          CategoriesReady(:final categories) => categories,
          _ => const <ExpenseCategory>[],
        };

        return BlocSelector<ExpenseFormCubit, ExpenseFormState, String?>(
          selector: (state) => state.category?.id,
          builder: (context, selectedId) => CategoryPicker(
            categories: categories,
            selectedId: selectedId,
            onSelected: context.read<ExpenseFormCubit>().selectCategory,
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormCubit, ExpenseFormState, bool>(
      selector: (state) => state.isSubmitting,
      builder: (context, isSubmitting) => FilledButton.icon(
        onPressed: isSubmitting ? null : onSubmit,
        icon: isSubmitting
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check_rounded),
        label: Text(context.strings.addExpense),
      ),
    );
  }
}
