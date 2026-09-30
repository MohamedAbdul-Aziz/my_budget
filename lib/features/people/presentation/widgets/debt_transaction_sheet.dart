import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/person_transaction_type.dart';
import '../../domain/usecases/add_person_transaction.dart';
import '../debt_labels.dart';

/// Returns why the transaction was refused, or null once it is saved.
/// [personId] is null only when the sheet asked for a person and none was
/// picked.
typedef DebtSave =
    Future<FailureCode?> Function({
      required String? personId,
      required String amountText,
      required PersonTransactionType type,
      required DateTime date,
      String? note,
    });

/// Record money that changed hands with a person, or change a record.
///
/// With [people] it first asks who with: the quick transaction from the
/// People tab. A refused save keeps the sheet open with the reason, so
/// nothing typed is lost.
class DebtTransactionSheet extends StatefulWidget {
  const DebtTransactionSheet({
    super.key,
    required this.onSave,
    this.existing,
    this.people,
  });

  final DebtSave onSave;
  final PersonTransaction? existing;

  /// Offered to choose from; null when the person is already known.
  final List<Person>? people;

  static Future<void> show(
    BuildContext context, {
    required DebtSave onSave,
    PersonTransaction? existing,
    List<Person>? people,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    // The amount field reads the currency from the app-level cubit.
    builder: (_) => BlocProvider.value(
      value: context.read<SettingsCubit>(),
      child: DebtTransactionSheet(
        onSave: onSave,
        existing: existing,
        people: people,
      ),
    ),
  );

  @override
  State<DebtTransactionSheet> createState() => _DebtTransactionSheetState();
}

class _DebtTransactionSheetState extends State<DebtTransactionSheet> {
  // Controllers belong to the State, never to build().
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  // Local UI state: the choices made so far, a save in flight, and why the
  // last one was refused.
  String? _personId;
  late PersonTransactionType _type;
  late DateTime _date;
  bool _saving = false;
  FailureCode? _error;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _amountController = TextEditingController(
      text: existing == null ? '' : AmountInput.editable(existing.amount),
    );
    _noteController = TextEditingController(text: existing?.note ?? '');
    _type = existing?.type ?? PersonTransactionType.iPaidForThem;
    _date = existing?.date ?? DateTime.now();
    final people = widget.people;
    // Someone with only one person to choose has already chosen.
    if (people != null && people.length == 1) _personId = people.single.id;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final error = await widget.onSave(
      personId: widget.people == null ? '' : _personId,
      amountText: _amountController.text,
      type: _type,
      date: _date,
      note: _noteController.text,
    );
    if (!mounted) return;
    if (error == null) {
      navigator.pop();
    } else {
      setState(() {
        _saving = false;
        _error = error;
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final people = widget.people;
    final error = _error;
    final amountError = switch (error) {
      FailureCode.amountInvalid ||
      FailureCode.amountRequired ||
      FailureCode.amountTooLarge => error,
      _ => null,
    };
    final personError = error == FailureCode.personRequired ? error : null;
    final otherError =
        error != null && amountError == null && personError == null
        ? error
        : null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing != null
                  ? strings.editTransaction
                  : people != null
                  ? strings.quickTransaction
                  : strings.newTransaction,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            if (people != null) ...[
              DropdownButtonFormField<String>(
                initialValue: _personId,
                decoration: InputDecoration(
                  labelText: strings.person,
                  errorText: personError == null
                      ? null
                      : strings.failure(personError),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                items: [
                  for (final person in people)
                    DropdownMenuItem(
                      value: person.id,
                      child: Text(person.name, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (id) => setState(() => _personId = id),
              ),
              const SizedBox(height: 16),
            ],
            _TypeToggle(
              selected: _type,
              onChanged: (type) => setState(() => _type = type),
            ),
            const SizedBox(height: 16),
            _AmountField(
              controller: _amountController,
              autofocus: widget.existing == null && people == null,
              error: amountError == null ? null : strings.failure(amountError),
            ),
            const SizedBox(height: 16),
            _DateChips(
              date: _date,
              onToday: () => setState(() => _date = DateTime.now()),
              onYesterday: () => setState(
                () => _date = DateTime.now().subtract(const Duration(days: 1)),
              ),
              onPick: _pickDate,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              maxLength: AddPersonTransaction.maxNoteLength,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: strings.noteOptional,
                hintText: strings.debtNoteHint,
                counterText: '',
                prefixIcon: const Icon(Icons.notes_rounded),
              ),
            ),
            if (otherError != null) ...[
              const SizedBox(height: 12),
              Text(
                strings.failure(otherError),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: Text(
                widget.existing != null ? strings.saveChanges : strings.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// I paid for them, or they paid for me, in the colors of what each does to
/// the balance.
class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.selected, required this.onChanged});

  final PersonTransactionType selected;
  final ValueChanged<PersonTransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final accent = debtColor(context, debtTypeDirection(selected));

    return SegmentedButton<PersonTransactionType>(
      segments: [
        for (final type in PersonTransactionType.values)
          ButtonSegment(
            value: type,
            icon: Icon(debtTypeIcon(type)),
            label: Text(debtTypeLabel(strings, type)),
          ),
      ],
      selected: {selected},
      showSelectedIcon: false,
      expandedInsets: EdgeInsets.zero,
      onSelectionChanged: (types) => onChanged(types.first),
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? accent : null,
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accent.withValues(alpha: 0.12)
              : null,
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
    required this.autofocus,
    this.error,
  });

  final TextEditingController controller;
  final bool autofocus;
  final String? error;

  @override
  Widget build(BuildContext context) {
    // Only the currency symbol is read from settings here.
    final symbol = context.select<SettingsCubit, String>(
      (cubit) => cubit.state.formats.symbol,
    );
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: AmountInput.formatters,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: context.strings.amountHint,
        prefixText: '$symbol ',
        errorText: error,
      ),
    );
  }
}

/// Today / Yesterday / any other day.
class _DateChips extends StatelessWidget {
  const _DateChips({
    required this.date,
    required this.onToday,
    required this.onYesterday,
    required this.onPick,
  });

  final DateTime date;
  final VoidCallback onToday;
  final VoidCallback onYesterday;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final daysAgo = AppFormats.daysAgo(date);

    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: Text(strings.today),
          selected: daysAgo == 0,
          onSelected: (_) => onToday(),
        ),
        ChoiceChip(
          label: Text(strings.yesterday),
          selected: daysAgo == 1,
          onSelected: (_) => onYesterday(),
        ),
        ChoiceChip(
          avatar: const Icon(Icons.calendar_today_rounded, size: 16),
          label: Text(
            daysAgo > 1 ? formats.dayAndMonth(date) : strings.pickADate,
          ),
          selected: daysAgo > 1,
          onSelected: (_) => onPick(),
        ),
      ],
    );
  }
}
