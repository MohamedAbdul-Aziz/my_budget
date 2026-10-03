import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../../core/utils/category_icons.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/debt_balance.dart';
import '../../domain/entities/people_filter.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_summary.dart';
import '../cubit/people_cubit.dart';
import '../cubit/people_state.dart';
import '../debt_labels.dart';
import '../widgets/debt_transaction_sheet.dart';
import '../widgets/person_avatar.dart';
import '../widgets/person_editor_sheet.dart';
import 'person_ledger_page.dart';

/// Everyone the user shares costs with, and where the user stands with each.
class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.people)),
      body: BlocConsumer<PeopleCubit, PeopleState>(
        listenWhen: (_, current) =>
            current is PeopleReady && current.notice != null,
        listener: (context, state) {
          final notice = (state as PeopleReady).notice!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.strings.notice(notice))),
            );
        },
        builder: (context, state) => switch (state) {
          PeopleLoading() => const Center(child: CircularProgressIndicator()),
          PeopleLoadFailure(:final failure) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    strings.failure(failure.code),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: context.read<PeopleCubit>().load,
                    child: Text(strings.tryAgain),
                  ),
                ],
              ),
            ),
          ),
          PeopleReady() when state.people.isEmpty => const _NoPeople(),
          PeopleReady() => _PeopleList(state: state),
        },
      ),
    );
  }

  /// Opens [person]'s ledger.
  static Future<void> openLedger(BuildContext context, Person person) =>
      Navigator.of(context).push(PersonLedgerPage.route(person.id));
}

/// Adds a person, or records a quick transaction with someone already
/// added.
///
/// The app shell's scaffold hosts it, like the home tab's add button, so
/// snackbars lift it instead of covering it.
class AddPeopleButton extends StatelessWidget {
  const AddPeopleButton({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
    onPressed: () => _choose(context),
    icon: const Icon(Icons.add_rounded),
    label: Text(context.strings.add),
  );

  Future<void> _choose(BuildContext context) async {
    final strings = context.strings;
    final quick = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: Text(strings.addPerson),
              subtitle: Text(strings.addPersonHint),
              onTap: () => Navigator.of(sheetContext).pop(false),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded),
              title: Text(strings.quickTransaction),
              subtitle: Text(strings.quickTransactionHint),
              onTap: () => Navigator.of(sheetContext).pop(true),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (quick == null || !context.mounted) return;
    if (quick) {
      await _quickTransaction(context);
    } else {
      await addPerson(context);
    }
  }

  /// Asks for the person's details, then opens their ledger so the first
  /// transaction is one tap away.
  static Future<void> addPerson(BuildContext context) async {
    final cubit = context.read<PeopleCubit>();
    final count = switch (cubit.state) {
      PeopleReady(:final people) => people.length,
      _ => 0,
    };
    Person? added;
    await PersonEditorSheet.show(
      context,
      // Each new person gets the next color, so a list reads at a glance.
      suggestedColor:
          CategoryColors.palette[count % CategoryColors.palette.length],
      onSave: ({required name, required colorValue, phone}) async {
        final result = await cubit.addPerson(
          name: name,
          colorValue: colorValue,
          phone: phone,
        );
        added = result.dataOrNull;
        return result.failureOrNull?.code;
      },
    );
    final person = added;
    if (person != null && context.mounted) {
      await PeoplePage.openLedger(context, person);
    }
  }

  static Future<void> _quickTransaction(BuildContext context) async {
    final cubit = context.read<PeopleCubit>();
    final people = switch (cubit.state) {
      PeopleReady(:final people) => [for (final p in people) p.person],
      _ => const <Person>[],
    };
    if (people.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.strings.addPersonFirst)));
      return;
    }
    await DebtTransactionSheet.show(
      context,
      people: people,
      onSave: cubit.addTransaction,
    );
  }
}

class _PeopleList extends StatelessWidget {
  const _PeopleList({required this.state});

  final PeopleReady state;

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when the language or currency changes.
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final visible = state.visible;

    return RefreshIndicator(
      onRefresh: context.read<PeopleCubit>().refresh,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _TotalsCard(
                owedToMe: state.owedToMe,
                iOwe: state.iOwe,
                formats: formats,
              ),
            ),
          ),
          SliverToBoxAdapter(child: _FilterChips(selected: state.filter)),
          if (visible.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 96),
                  child: Text(
                    context.strings.nobodyHere,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
              sliver: SliverList.builder(
                itemCount: visible.length,
                itemBuilder: (context, index) =>
                    _PersonTile(summary: visible[index], formats: formats),
              ),
            ),
        ],
      ),
    );
  }
}

/// What everyone owes the user, and what the user owes everyone.
class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.owedToMe,
    required this.iOwe,
    required this.formats,
  });

  final DebtBalance owedToMe;
  final DebtBalance iOwe;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: _Total(
                label: strings.owedToYou,
                amount: formats.money(owedToMe.magnitude),
                color: debtColor(
                  context,
                  owedToMe.isSettled
                      ? DebtDirection.settled
                      : DebtDirection.owedToMe,
                ),
              ),
            ),
            Expanded(
              child: _Total(
                label: strings.youOwe,
                amount: formats.money(iOwe.magnitude),
                color: debtColor(
                  context,
                  iOwe.isSettled ? DebtDirection.settled : DebtDirection.iOwe,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// All / Owed to me / I owe / Settled.
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected});

  final PeopleFilter selected;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          for (final filter in PeopleFilter.values)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(peopleFilterLabel(strings, filter)),
                selected: filter == selected,
                onSelected: (_) =>
                    context.read<PeopleCubit>().selectFilter(filter),
              ),
            ),
        ],
      ),
    );
  }
}

/// A person and their net balance: green when they owe the user, red when
/// the user owes them, grey when settled.
class _PersonTile extends StatelessWidget {
  const _PersonTile({required this.summary, required this.formats});

  final PersonSummary summary;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final direction = summary.balance.direction;
    final lastActivity = summary.lastActivity;

    return ListTile(
      onTap: () => PeoplePage.openLedger(context, summary.person),
      leading: PersonAvatar(person: summary.person),
      title: Text(
        summary.person.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        [
          debtStanding(strings, direction),
          if (lastActivity != null) strings.dayLabel(lastActivity, formats),
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formats.money(summary.balance.magnitude),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: debtColor(context, direction),
        ),
      ),
    );
  }
}

class _NoPeople extends StatelessWidget {
  const _NoPeople();

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
              Icons.people_outline_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              strings.noPeopleYet,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.noPeopleHint,
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
