import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../../../categories/presentation/widgets/category_editor_sheet.dart';
import '../../../categories/presentation/widgets/category_picker.dart';
import '../../../expenses/presentation/widgets/transaction_type_toggle.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/recurrence_frequency.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/entities/recurring_mode.dart';
import '../cubit/recurring_cubit.dart';
import '../cubit/recurring_form_cubit.dart';
import '../cubit/recurring_form_state.dart';

/// Add or edit one recurring payment: its name, amount and category, how
/// often it repeats and on which day, and whether the app logs it on its own
/// or asks first.
class RecurringFormPage extends StatefulWidget {
  const RecurringFormPage({super.key, this.existing});

  final RecurringExpense? existing;

  /// Pops with `true` once something has been saved.
  static Route<bool> route({RecurringExpense? existing}) {
    final suggested = categoriesOfType(
      sl<CategoriesCubit>().state,
      TransactionType.expense,
    ).firstOrNull;

    return MaterialPageRoute<bool>(
      builder: (_) => BlocProvider(
        create: (_) =>
            sl<RecurringFormCubit>()
              ..start(existing: existing, suggestedCategory: suggested),
        child: RecurringFormPage(existing: existing),
      ),
    );
  }

  @override
  State<RecurringFormPage> createState() => _RecurringFormPageState();
}

class _RecurringFormPageState extends State<RecurringFormPage> {
  // Created once here — never inside build().
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _amountController = TextEditingController(
      text: existing == null ? '' : AmountInput.editable(existing.amount),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() => context.read<RecurringFormCubit>().submit(
    title: _titleController.text,
    amountText: _amountController.text,
  );

  Future<void> _createCategory() async {
    final categoriesCubit = context.read<CategoriesCubit>();
    final formCubit = context.read<RecurringFormCubit>();
    final draft = await CategoryEditorSheet.show(
      context,
      type: TransactionType.expense,
    );
    if (draft == null) return;

    final created = await categoriesCubit.create(
      name: draft.name,
      iconName: draft.iconName,
      colorValue: draft.colorValue,
      type: draft.type,
    );
    // Selecting it immediately saves the user a second tap.
    if (created != null) formCubit.selectCategory(created);
  }

  Future<void> _confirmDelete(RecurringExpense existing) async {
    final strings = context.strings;
    final recurringCubit = context.read<RecurringCubit>();
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.deleteCategoryTitle(existing.title)),
        content: Text(strings.deleteRecurringBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await recurringCubit.remove(existing);
    navigator.pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final existing = widget.existing;

    return BlocListener<RecurringFormCubit, RecurringFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case RecurringFormStatus.success:
            Navigator.of(context).pop(true);
          case RecurringFormStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    context.strings.failure(state.error ?? FailureCode.unknown),
                  ),
                ),
              );
          case RecurringFormStatus.editing || RecurringFormStatus.submitting:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(
            existing == null ? strings.newRecurring : strings.editRecurring,
          ),
          actions: [
            if (existing != null)
              IconButton(
                tooltip: strings.delete,
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () => _confirmDelete(existing),
              ),
            const SizedBox(width: 4),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            TextField(
              controller: _titleController,
              autofocus: existing == null,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              maxLength: RecurringExpense.maxTitleLength,
              decoration: InputDecoration(
                labelText: strings.recurringTitle,
                hintText: strings.recurringTitleHint,
                counterText: '',
                prefixIcon: const Icon(Icons.edit_note_rounded),
              ),
            ),
            const SizedBox(height: 16),
            _AmountField(controller: _amountController),
            const SizedBox(height: 24),
            _FieldLabel(strings.category),
            _CategorySection(onCreate: _createCategory),
            const SizedBox(height: 24),
            _FieldLabel(strings.repeats),
            const _FrequencySelector(),
            const SizedBox(height: 20),
            _FieldLabel(strings.dueOn),
            const _DueSelector(),
            const SizedBox(height: 24),
            _FieldLabel(strings.whenDue),
            const _ModeSelector(),
          ],
        ),
        bottomNavigationBar: _SubmitBar(
          isEditing: existing != null,
          onSubmit: _submit,
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // Only the currency symbol is read from settings here.
    final symbol = context.select<SettingsCubit, String>(
      (cubit) => cubit.state.formats.symbol,
    );
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: AmountInput.formatters,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: context.strings.amount,
        hintText: context.strings.amountHint,
        prefixText: '$symbol ',
      ),
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

/// Spending categories only: a recurring payment is money going out.
class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, categoriesState) =>
          BlocSelector<RecurringFormCubit, RecurringFormState, String?>(
            selector: (state) => state.category?.id,
            builder: (context, selectedId) => CategoryPicker(
              categories: categoriesOfType(
                categoriesState,
                TransactionType.expense,
              ),
              selectedId: selectedId,
              onSelected: context.read<RecurringFormCubit>().selectCategory,
              onCreate: onCreate,
            ),
          ),
    );
  }
}

class _FrequencySelector extends StatelessWidget {
  const _FrequencySelector();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return BlocSelector<
      RecurringFormCubit,
      RecurringFormState,
      RecurrenceFrequency
    >(
      selector: (state) => state.frequency,
      builder: (context, frequency) => SegmentedButton<RecurrenceFrequency>(
        segments: [
          for (final option in RecurrenceFrequency.values)
            ButtonSegment(
              value: option,
              label: Text(strings.frequencyName(option)),
            ),
        ],
        selected: {frequency},
        showSelectedIcon: false,
        onSelectionChanged: (selection) =>
            context.read<RecurringFormCubit>().selectFrequency(selection.first),
      ),
    );
  }
}

/// A weekday for a weekly payment, a day of the month for a monthly one,
/// and a day of the year for a yearly one.
class _DueSelector extends StatelessWidget {
  const _DueSelector();

  @override
  Widget build(BuildContext context) {
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    return BlocSelector<
      RecurringFormCubit,
      RecurringFormState,
      (RecurrenceFrequency, int, int)
    >(
      selector: (state) => (state.frequency, state.dueDay, state.dueMonth),
      builder: (context, schedule) {
        final (frequency, day, month) = schedule;
        return switch (frequency) {
          RecurrenceFrequency.weekly => _WeekdayPicker(
            weekday: day,
            formats: formats,
          ),
          RecurrenceFrequency.monthly => _DayOfMonthPicker(
            day: day,
            formats: formats,
          ),
          RecurrenceFrequency.yearly => _DayOfYearPicker(
            month: month,
            day: day,
            formats: formats,
          ),
        };
      },
    );
  }
}

class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({required this.weekday, required this.formats});

  final int weekday;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecurringFormCubit>();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var option = DateTime.monday; option <= DateTime.sunday; option++)
          ChoiceChip(
            label: Text(formats.shortWeekdayName(option)),
            tooltip: formats.weekdayName(option),
            selected: option == weekday,
            onSelected: (_) => cubit.selectDueDay(option),
          ),
      ],
    );
  }
}

class _DayOfMonthPicker extends StatelessWidget {
  const _DayOfMonthPicker({required this.day, required this.formats});

  final int day;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return DropdownButtonFormField<int>(
      // Keyed by the value, so a change made elsewhere shows up here.
      key: ValueKey(('day', day)),
      initialValue: day,
      menuMaxHeight: 360,
      decoration: InputDecoration(
        labelText: strings.dueDayOfMonth,
        helperText: day > 28 ? strings.shortMonthHint : null,
        helperMaxLines: 2,
      ),
      items: [
        for (var option = 1; option <= 31; option++)
          DropdownMenuItem(value: option, child: Text(formats.number(option))),
      ],
      onChanged: (value) {
        if (value != null) {
          context.read<RecurringFormCubit>().selectDueDay(value);
        }
      },
    );
  }
}

class _DayOfYearPicker extends StatelessWidget {
  const _DayOfYearPicker({
    required this.month,
    required this.day,
    required this.formats,
  });

  final int month;
  final int day;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final cubit = context.read<RecurringFormCubit>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            key: ValueKey(('month', month)),
            initialValue: month,
            menuMaxHeight: 360,
            isExpanded: true,
            decoration: InputDecoration(labelText: strings.dueMonthLabel),
            items: [
              for (var option = 1; option <= 12; option++)
                DropdownMenuItem(
                  value: option,
                  child: Text(
                    formats.monthName(option),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) cubit.selectDueMonth(value);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<int>(
            // The month decides how many days there are to pick from.
            key: ValueKey(('day', month, day)),
            initialValue: day,
            menuMaxHeight: 360,
            isExpanded: true,
            decoration: InputDecoration(labelText: strings.dueDayLabel),
            items: [
              for (
                var option = 1;
                option <= RecurringExpense.longestMonth(month);
                option++
              )
                DropdownMenuItem(
                  value: option,
                  child: Text(formats.number(option)),
                ),
            ],
            onChanged: (value) {
              if (value != null) cubit.selectDueDay(value);
            },
          ),
        ),
      ],
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    return BlocSelector<RecurringFormCubit, RecurringFormState, RecurringMode>(
      selector: (state) => state.mode,
      builder: (context, mode) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<RecurringMode>(
            segments: [
              ButtonSegment(
                value: RecurringMode.reminder,
                icon: const Icon(Icons.notifications_active_outlined),
                label: Text(strings.remindMe),
              ),
              ButtonSegment(
                value: RecurringMode.autoDeduct,
                icon: const Icon(Icons.autorenew_rounded),
                label: Text(strings.autoDeduct),
              ),
            ],
            selected: {mode},
            showSelectedIcon: false,
            onSelectionChanged: (selection) =>
                context.read<RecurringFormCubit>().selectMode(selection.first),
          ),
          const SizedBox(height: 8),
          Text(
            switch (mode) {
              RecurringMode.reminder => strings.remindMeHint,
              RecurringMode.autoDeduct => strings.autoDeductHint,
            },
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
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
    return BlocSelector<RecurringFormCubit, RecurringFormState, bool>(
      selector: (state) => state.isSubmitting,
      builder: (context, isSubmitting) => SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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
                : context.strings.addRecurring,
          ),
        ),
      ),
    );
  }
}
