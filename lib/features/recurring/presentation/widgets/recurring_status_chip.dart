import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../domain/entities/recurring_overview.dart';
import '../recurring_labels.dart';

/// "Paid", "Upcoming" or "Overdue", tinted with its status color.
class RecurringStatusChip extends StatelessWidget {
  const RecurringStatusChip({super.key, required this.commitment});

  final RecurringCommitment commitment;

  @override
  Widget build(BuildContext context) {
    final color = commitment.statusColor(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              commitment.statusLabel(context.strings),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
