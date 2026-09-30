import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/person_transaction_edit.dart';
import '../debt_labels.dart';
import 'debt_tile.dart';

/// What the user chose to do from the details sheet.
enum DebtDetailsAction { edit, delete }

/// One transaction in full: its audit trail (recorded, last edited,
/// settled) and every earlier version from its change log. An open
/// transaction can be edited or deleted from here; a settled one is locked.
class DebtDetailsSheet extends StatelessWidget {
  const DebtDetailsSheet({
    super.key,
    required this.transaction,
    required this.formats,
  });

  final PersonTransaction transaction;
  final AppFormats formats;

  static Future<DebtDetailsAction?> show(
    BuildContext context, {
    required PersonTransaction transaction,
    required AppFormats formats,
  }) => showModalBottomSheet<DebtDetailsAction>(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        DebtDetailsSheet(transaction: transaction, formats: formats),
  );

  String _moment(DateTime time) =>
      '${formats.fullDate(time)}, ${formats.time(time)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final t = transaction;
    final color = debtColor(context, debtTypeDirection(t.type));
    final settledAt = t.settledAt;
    final lastEditedAt = t.lastEditedAt;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text(
              strings.transactionDetails,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(debtTypeIcon(t.type), color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    debtTypeLabel(strings, t.type),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  signedDebtAmount(t, formats),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (t.note case final note?) ...[
              const SizedBox(height: 8),
              Text(note, style: theme.textTheme.bodyLarge),
            ],
            const SizedBox(height: 16),
            _Fact(label: strings.colDate, value: formats.fullDate(t.date)),
            _Fact(label: strings.createdOn, value: _moment(t.createdAt)),
            if (lastEditedAt != null)
              _Fact(label: strings.lastEdited, value: _moment(lastEditedAt)),
            if (settledAt != null)
              _Fact(label: strings.settledOn, value: _moment(settledAt)),
            if (t.wasEdited) ...[
              const SizedBox(height: 16),
              Text(strings.changeHistory, style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              // Newest edit first; each shows what it replaced.
              for (final edit in t.edits.reversed)
                _EditEntry(edit: edit, formats: formats),
            ],
            const SizedBox(height: 20),
            if (t.isSettled)
              Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      strings.settledLocked,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(strings.delete),
                    onPressed: () =>
                        Navigator.of(context).pop(DebtDetailsAction.delete),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(strings.edit),
                    onPressed: () =>
                        Navigator.of(context).pop(DebtDetailsAction.edit),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

/// One change-log entry: when the edit was made, and the values it replaced.
class _EditEntry extends StatelessWidget {
  const _EditEntry({required this.edit, required this.formats});

  final PersonTransactionEdit edit;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final values = [
      formats.money(edit.amount),
      debtTypeLabel(strings, edit.type),
      formats.fullDate(edit.date),
      ?edit.note,
    ].join(' · ');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: const Icon(Icons.history_rounded),
      title: Text(
        strings.editedOn(
          '${formats.fullDate(edit.editedAt)}, ${formats.time(edit.editedAt)}',
        ),
      ),
      subtitle: Text(
        strings.wasValues(values),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
