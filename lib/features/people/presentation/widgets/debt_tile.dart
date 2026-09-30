import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/person_transaction_type.dart';
import '../debt_labels.dart';

/// `+$12.00` when the person owes the user more because of it, `-$12.00`
/// when the user owes the person more.
String signedDebtAmount(PersonTransaction transaction, AppFormats formats) {
  final amount = formats.money(transaction.amount);
  return switch (transaction.type) {
    PersonTransactionType.iPaidForThem => '+$amount',
    PersonTransactionType.theyPaidForMe => '-$amount',
  };
}

/// One transaction in a person's ledger.
class DebtTile extends StatelessWidget {
  const DebtTile({
    super.key,
    required this.transaction,
    required this.formats,
    required this.onTap,
  });

  final PersonTransaction transaction;
  final AppFormats formats;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final color = debtColor(context, debtTypeDirection(transaction.type));
    final type = debtTypeLabel(strings, transaction.type);
    final note = transaction.note;
    final details = [
      if (note != null) type,
      strings.dayLabel(transaction.date, formats),
      if (transaction.wasEdited) strings.edited,
    ].join(' · ');

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(debtTypeIcon(transaction.type), color: color, size: 20),
      ),
      title: Text(
        note ?? type,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(details, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        signedDebtAmount(transaction, formats),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
