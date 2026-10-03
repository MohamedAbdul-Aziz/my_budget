import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/recurring_overview.dart';
import '../cubit/recurring_cubit.dart';
import '../cubit/recurring_state.dart';
import '../pages/recurring_page.dart';
import '../recurring_labels.dart';
import 'recurring_tile.dart';

/// The home screen's prompt for reminders: each payment due today or
/// overdue, with a button to confirm it was paid. Out of the way entirely
/// while nothing is due.
class RecurringDueCard extends StatelessWidget {
  const RecurringDueCard({super.key});

  /// More than this and the card would push the month's transactions off
  /// the screen; the rest are one tap away.
  static const int _shown = 3;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RecurringCubit,
      RecurringState,
      List<RecurringCommitment>
    >(
      selector: (state) => switch (state) {
        RecurringReady(:final overview) => overview.awaitingConfirmation,
        RecurringLoading() || RecurringLoadFailure() => const [],
      },
      builder: (context, due) => due.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _DueCard(due: due),
            ),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({required this.due});

  final List<RecurringCommitment> due;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event_repeat_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    strings.paymentsToConfirm,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).push(RecurringPage.route()),
                  child: Text(strings.seeAll),
                ),
              ],
            ),
            for (final item in due.take(RecurringDueCard._shown))
              _DueRow(commitment: item, formats: formats),
          ],
        ),
      ),
    );
  }
}

class _DueRow extends StatelessWidget {
  const _DueRow({required this.commitment, required this.formats});

  final RecurringCommitment commitment;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recurring = commitment.recurring;

    // The button gets a line of its own: beside the text it would squeeze
    // a long name or date to nothing on a small phone.
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8, bottom: 4, end: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              CategoryAvatar(category: recurring.category, size: 36),
              const SizedBox(width: 12),
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
                    Text(
                      '${recurring.isIncome ? '+' : ''}'
                      '${formats.money(recurring.amount)} · '
                      '${commitment.dueLabel(context.strings, formats)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: commitment.statusColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          MarkPaidButton(
            isIncome: recurring.isIncome,
            onPressed: () => context.read<RecurringCubit>().markPaid(recurring),
          ),
        ],
      ),
    );
  }
}
