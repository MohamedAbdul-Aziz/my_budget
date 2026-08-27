import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../../../categories/presentation/widgets/category_editor_sheet.dart';
import '../../../categories/presentation/widgets/category_picker.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_form_cubit.dart';
import '../cubit/expense_form_state.dart';

/// Add or edit one expense. Amount is focused on open, the category list is
/// fully visible, and the date already says Today — so the fastest path to a
/// saved expense is: type a number, tap Add.
class ExpenseFormPage extends StatefulWidget {
  const ExpenseFormPage({super.key, this.existing});

  final Expense? existing;

  /// Pops with `true` once an expense has been saved.
  static Route<bool> route({Expense? existing}) {
    final categoriesState = sl<CategoriesCubit>().state;
    final suggested = switch (categoriesState) {
      CategoriesReady(:final categories) when categories.isNotEmpty =>
        categories.first,
      _ => null,
    };

    return MaterialPageRoute<bool>(
      builder: (_) => BlocProvider(
        create: (_) => sl<ExpenseFormCubit>()
          ..start(existing: existing, suggestedCategory: suggested),
        child: ExpenseFormPage(existing: existing),
      ),
    );
  }

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  // Created once here — never inside build().
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late final FocusNode _amountFocus;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _amountController = TextEditingController(
      text: existing == null ? '' : _trimZeros(existing.amount),
    );
    _noteController = TextEditingController(text: existing?.description ?? '');
    _amountFocus = FocusNode();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  static String _trimZeros(double amount) => amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);

  void _submit() => context.read<ExpenseFormCubit>().submit(
    amountText: _amountController.text,
    description: _noteController.text,
  );

  Future<void> _createCategory() async {
    final categoriesCubit = context.read<CategoriesCubit>();
    final formCubit = context.read<ExpenseFormCubit>();
    final draft = await CategoryEditorSheet.show(context);
    if (draft == null) return;

    final created = await categoriesCubit.create(
      name: draft.name,
      iconName: draft.iconName,
      colorValue: draft.colorValue,
    );
    // Selecting it immediately saves the user a second tap.
    if (created != null) formCubit.selectCategory(created);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
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
                    context.strings.failure(
                      state.error ?? FailureCode.unknown,
                    ),
                  ),
                ),
              );
          case ExpenseFormStatus.editing || ExpenseFormStatus.submitting:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(isEditing ? strings.editExpense : strings.newExpense),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _AmountField(controller: _amountController, focusNode: _amountFocus),
            const SizedBox(height: 24),
            _FieldLabel(strings.when),
            const _DateSelector(),
            const SizedBox(height: 24),
            _FieldLabel(strings.category),
            _CategorySection(onCreate: _createCategory),
            const SizedBox(height: 24),
            _FieldLabel(strings.noteOptional),
            TextField(
              controller: _noteController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              maxLength: 80,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: strings.noteHint,
                counterText: '',
                prefixIcon: const Icon(Icons.notes_rounded),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _SubmitBar(
          isEditing: isEditing,
          onSubmit: _submit,
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Only the currency symbol is read from settings here.
    final symbol = context.select<SettingsCubit, String>(
      (cubit) => cubit.state.formats.symbol,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          symbol,
          style: theme.textTheme.headlineMedium?.copyWith(
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

/// Today / Yesterday / any other day — two taps at most.
class _DateSelector extends StatelessWidget {
  const _DateSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormCubit, ExpenseFormState, DateTime>(
      selector: (state) => state.date,
      builder: (context, date) {
        final strings = context.strings;
        final formats = context.select<SettingsCubit, AppFormats>(
          (cubit) => cubit.state.formats,
        );
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));
        final isToday = AppFormats.isSameDay(date, now);
        final isYesterday = AppFormats.isSameDay(date, yesterday);
        final isCustom = !isToday && !isYesterday;

        return Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(strings.today),
              selected: isToday,
              onSelected: (_) =>
                  context.read<ExpenseFormCubit>().selectDate(now),
            ),
            ChoiceChip(
              label: Text(strings.yesterday),
              selected: isYesterday,
              onSelected: (_) =>
                  context.read<ExpenseFormCubit>().selectDate(yesterday),
            ),
            ChoiceChip(
              avatar: const Icon(Icons.calendar_today_rounded, size: 16),
              label: Text(
                isCustom ? formats.dayAndMonth(date) : strings.pickADate,
              ),
              selected: isCustom,
              onSelected: (_) => _pick(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pick(BuildContext context) async {
    final cubit = context.read<ExpenseFormCubit>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.date,
      firstDate: DateTime(now.year - 5),
      // Future-dating an expense is rarely intended.
      lastDate: now,
    );
    if (picked != null) cubit.selectDate(picked);
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.onCreate});

  final VoidCallback onCreate;

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
            onCreate: onCreate,
          ),
        );
      },
    );
  }
}

/// Pinned above the keyboard so the primary action is always reachable.
class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.isEditing, required this.onSubmit});

  final bool isEditing;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormCubit, ExpenseFormState, bool>(
      selector: (state) => state.isSubmitting,
      builder: (context, isSubmitting) => SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: FilledButton.icon(
            onPressed: isSubmitting ? null : onSubmit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(isEditing ? Icons.check_rounded : Icons.add_rounded),
            label: Text(
              isEditing
                  ? context.strings.saveChanges
                  : context.strings.addExpense,
            ),
          ),
        ),
      ),
    );
  }
}
