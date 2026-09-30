import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/transaction_colors.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../domain/entities/recurring_overview.dart';
import '../recurring_labels.dart';
import 'recurring_status_chip.dart';

/// One recurring payment: what it is, when it repeats, where it stands this
/// month, and, while it is due, a button to mark it paid. Tapping it opens
/// it for editing.
class RecurringTile extends StatelessWidget {
  const RecurringTile({
    super.key,
    required this.commitment,
    required this.formats,
    required this.onTap,
    required this.onMarkPaid,
  });

  final RecurringCommitment commitment;
  final AppFormats formats;
  final VoidCallback onTap;
  final VoidCallback onMarkPaid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final recurring = commitment.recurring;
    final late =
        commitment.status == RecurringStatus.overdue || commitment.isDueToday;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryAvatar(category: recurring.category),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recurring.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          scheduleLabel(strings, recurring, formats),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        recurring.isIncome
                            ? '+${formats.money(recurring.amount)}'
                            : formats.money(recurring.amount),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: recurring.isIncome
                              ? TransactionColors.of(context).income
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RecurringStatusChip(commitment: commitment),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.event_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      commitment.dueLabel(strings, formats),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: late
                            ? commitment.statusColor(context)
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: late ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                  if (commitment.isPayableNow) ...[
                    const SizedBox(width: 8),
                    MarkPaidButton(
                      isIncome: recurring.isIncome,
                      onPressed: onMarkPaid,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The compact "Mark as paid" button shared by the list and the home card;
/// "Mark as received" for income.
class MarkPaidButton extends StatelessWidget {
  const MarkPaidButton({
    super.key,
    required this.onPressed,
    this.isIncome = false,
  });

  final VoidCallback onPressed;
  final bool isIncome;

  @override
  Widget build(BuildContext context) => FilledButton.tonalIcon(
    // The theme's full-width button would not fit beside the text.
    style: FilledButton.styleFrom(
      minimumSize: const Size(64, 40),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
    onPressed: onPressed,
    icon: const Icon(Icons.check_rounded, size: 18),
    label: Text(
      isIncome ? context.strings.markAsReceived : context.strings.markAsPaid,
    ),
  );
}
