import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/assistant_sharing.dart';
import '../cubit/assistant_cubit.dart';
import '../cubit/assistant_state.dart';

/// Lets the user choose what goes out with each question: how far back, and
/// anything beyond the totals. Every change is saved at once.
class AssistantSharingSheet extends StatelessWidget {
  const AssistantSharingSheet({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<AssistantCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AssistantSharingSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    final sharing = context.select<AssistantCubit, AssistantSharing>(
      (cubit) => switch (cubit.state) {
        AssistantReady(:final sharing) => sharing,
        _ => AssistantSharing.defaults,
      },
    );
    // Each change applies to the latest choices, not the ones this build
    // saw, so quick taps in a row all count.
    void update(AssistantSharing Function(AssistantSharing) change) =>
        context.read<AssistantCubit>().changeSharing(change);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.assistantSharingTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              strings.assistantSharingIntro,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(strings.assistantPeriod, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            _RangeChips(sharing: sharing, onChanged: update),
            const SizedBox(height: 8),
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(strings.assistantShareTransactions),
              subtitle: Text(strings.assistantShareTransactionsHint),
              value: sharing.transactions,
              onChanged: (on) => update((s) => s.copyWith(transactions: on)),
            ),
            SwitchListTile(
              contentPadding: const EdgeInsetsDirectional.only(start: 16),
              title: Text(strings.assistantShareNotes),
              subtitle: Text(strings.assistantShareNotesHint),
              // Notes only travel inside transactions.
              value: sharing.sendsDescriptions,
              onChanged: sharing.transactions
                  ? (on) => update((s) => s.copyWith(descriptions: on))
                  : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(strings.assistantShareRecurring),
              subtitle: Text(strings.assistantShareRecurringHint),
              value: sharing.recurring,
              onChanged: (on) => update((s) => s.copyWith(recurring: on)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(strings.assistantSharePeople),
              subtitle: Text(strings.assistantSharePeopleHint),
              value: sharing.people,
              onChanged: (on) => update((s) => s.copyWith(people: on)),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: sharing.isDefault
                  ? null
                  : () => update((_) => AssistantSharing.defaults),
              icon: const Icon(Icons.restart_alt),
              label: Text(strings.assistantSharingReset),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeChips extends StatelessWidget {
  const _RangeChips({required this.sharing, required this.onChanged});

  final AssistantSharing sharing;
  final void Function(AssistantSharing Function(AssistantSharing)) onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final custom = sharing.range == AssistantRange.custom
        ? sharing.resolve(DateTime.now())
        : null;

    String label(AssistantRange range) => switch (range) {
      AssistantRange.thisMonth => strings.assistantRangeThisMonth,
      AssistantRange.last3Months => strings.assistantRangeLast3Months,
      AssistantRange.last6Months => strings.assistantRangeLast6Months,
      AssistantRange.thisYear => strings.assistantRangeThisYear,
      AssistantRange.custom when custom != null =>
        '${formats.fullDate(custom.start)} – ${formats.fullDate(custom.lastDay)}',
      AssistantRange.custom => strings.assistantRangeCustom,
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final range in AssistantRange.values)
          ChoiceChip(
            label: Text(label(range)),
            selected: sharing.range == range,
            onSelected: (_) async {
              if (range != AssistantRange.custom) {
                onChanged((s) => s.copyWith(range: range));
                return;
              }
              final today = DateTime.now();
              final current = sharing.resolve(today);
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: today,
                initialDateRange: DateTimeRange(
                  start: current.start,
                  end: current.lastDay.isAfter(today) ? today : current.lastDay,
                ),
              );
              if (picked == null) return;
              onChanged(
                (s) => s.copyWith(
                  range: AssistantRange.custom,
                  customStart: picked.start,
                  customEnd: picked.end,
                ),
              );
            },
          ),
      ],
    );
  }
}
