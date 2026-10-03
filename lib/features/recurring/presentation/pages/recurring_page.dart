import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/status_colors.dart';
import '../../../../core/theme/transaction_colors.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/entities/recurring_overview.dart';
import '../cubit/recurring_cubit.dart';
import '../cubit/recurring_state.dart';
import '../widgets/recurring_tile.dart';
import 'recurring_form_page.dart';

/// Every recurring payment: what they cost in a month, and where each one
/// stands, the late ones first. Add, edit, delete and mark paid from here.
class RecurringPage extends StatelessWidget {
  const RecurringPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const RecurringPage());

  /// Opens the add/edit screen and reads the list again if something was
  /// saved. A new automatic payment due today is logged by that read.
  static Future<void> openForm(
    BuildContext context, {
    RecurringExpense? existing,
  }) async {
    final cubit = context.read<RecurringCubit>();
    final saved = await Navigator.of(
      context,
    ).push(RecurringFormPage.route(existing: existing));
    if (saved ?? false) await cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.recurringPayments)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(strings.add),
      ),
      body: BlocBuilder<RecurringCubit, RecurringState>(
        builder: (context, state) => switch (state) {
          RecurringLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          RecurringLoadFailure(:final error) => _LoadFailure(
            message: strings.failure(error),
          ),
          RecurringReady(:final overview) when overview.isEmpty =>
            const _EmptyList(),
          RecurringReady(:final overview) => _RecurringList(overview: overview),
        },
      ),
    );
  }
}

class _RecurringList extends StatelessWidget {
  const _RecurringList({required this.overview});

  final RecurringOverview overview;

  @override
  Widget build(BuildContext context) {
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final items = overview.commitments;

    return RefreshIndicator(
      onRefresh: context.read<RecurringCubit>().refresh,
      child: ListView.builder(
        // Clear of the floating button.
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _Summary(overview: overview, formats: formats),
            );
          }
          final item = items[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RecurringTile(
              key: ValueKey(item.recurring.id),
              commitment: item,
              formats: formats,
              onTap: () =>
                  RecurringPage.openForm(context, existing: item.recurring),
              onMarkPaid: () =>
                  context.read<RecurringCubit>().markPaid(item.recurring),
            ),
          );
        },
      ),
    );
  }
}

/// One figure of the summary: a label above an amount.
class _Average extends StatelessWidget {
  const _Average({required this.label, required this.amount, this.color});

  final String label;
  final String amount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// What they cost and bring in an average month, and how many are paid,
/// still to come, or late.
class _Summary extends StatelessWidget {
  const _Summary({required this.overview, required this.formats});

  final RecurringOverview overview;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final colors = StatusColors.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                // Spending is the usual case; income joins it once any
                // recurring income exists.
                if (overview.monthlySpending > 0 || overview.monthlyIncome == 0)
                  _Average(
                    label: strings.monthlyAverage,
                    amount: formats.moneyTight(overview.monthlySpending),
                  ),
                if (overview.monthlyIncome > 0)
                  _Average(
                    label: strings.monthlyIncomeAverage,
                    amount: '+${formats.moneyTight(overview.monthlyIncome)}',
                    color: TransactionColors.of(context).income,
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              strings.monthlyAverageHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                for (final (status, label, color) in [
                  (
                    RecurringStatus.overdue,
                    strings.statusOverdue,
                    colors.danger,
                  ),
                  (
                    RecurringStatus.upcoming,
                    strings.statusUpcoming,
                    theme.colorScheme.onSurfaceVariant,
                  ),
                  (RecurringStatus.paid, strings.statusPaid, colors.good),
                ])
                  if (overview.count(status) case final count when count > 0)
                    _Count(
                      label: label,
                      count: formats.number(count),
                      color: color,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.count, required this.color});

  final String label;
  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: style),
        const SizedBox(width: 4),
        Text(
          count,
          style: style?.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 96),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_repeat_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              strings.noRecurringYet,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.noRecurringHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: context.read<RecurringCubit>().load,
              child: Text(context.strings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
