import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../../expenses/presentation/cubit/home_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/debt_balance.dart';
import '../../domain/entities/person_ledger.dart';
import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/settlement.dart';
import '../cubit/people_cubit.dart';
import '../cubit/person_ledger_cubit.dart';
import '../cubit/person_ledger_state.dart';
import '../debt_labels.dart';
import '../widgets/debt_details_sheet.dart';
import '../widgets/debt_tile.dart';
import '../widgets/debt_transaction_sheet.dart';
import '../widgets/person_avatar.dart';
import '../widgets/person_editor_sheet.dart';

/// Everything recorded with one person: where the user stands, the open
/// transactions behind it, and the settled history.
class PersonLedgerPage extends StatelessWidget {
  const PersonLedgerPage({super.key});

  static Route<void> route(String personId) => MaterialPageRoute<void>(
    builder: (_) => BlocProvider(
      create: (_) => sl<PersonLedgerCubit>()..load(personId),
      child: const PersonLedgerPage(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // The People tab shows this person's balance too.
        BlocListener<PersonLedgerCubit, PersonLedgerState>(
          listenWhen: (previous, current) =>
              previous is PersonLedgerReady &&
              current is PersonLedgerReady &&
              previous.ledger != current.ledger,
          listener: (context, _) => context.read<PeopleCubit>().refresh(),
        ),
        BlocListener<PersonLedgerCubit, PersonLedgerState>(
          listenWhen: (_, current) =>
              current is PersonLedgerReady && current.notice != null,
          listener: (context, state) {
            final notice = (state as PersonLedgerReady).notice!;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(context.strings.notice(notice))),
              );
          },
        ),
      ],
      child: BlocBuilder<PersonLedgerCubit, PersonLedgerState>(
        builder: (context, state) => switch (state) {
          PersonLedgerLoading() => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          PersonLedgerLoadFailure(:final failure) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  context.strings.failure(failure.code),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          PersonLedgerReady(:final ledger) => _LedgerScaffold(ledger: ledger),
        },
      ),
    );
  }
}

enum _PersonAction { edit, delete }

class _LedgerScaffold extends StatelessWidget {
  const _LedgerScaffold({required this.ledger});

  final PersonLedger ledger;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(ledger.person.name, overflow: TextOverflow.ellipsis),
        actions: [
          PopupMenuButton<_PersonAction>(
            onSelected: (action) => switch (action) {
              _PersonAction.edit => _editPerson(context),
              _PersonAction.delete => _deletePerson(context),
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _PersonAction.edit,
                child: Text(strings.editPerson),
              ),
              PopupMenuItem(
                value: _PersonAction.delete,
                child: Text(strings.deletePerson),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTransaction(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(strings.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _BalanceCard(
                ledger: ledger,
                formats: formats,
                onSettle: () => _settle(context, formats),
              ),
            ),
          ),
          if (ledger.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyLedger(),
            )
          else ...[
            if (ledger.open.isNotEmpty) ...[
              _SectionHeader(strings.activeTransactions),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverList.builder(
                  itemCount: ledger.open.length,
                  itemBuilder: (context, index) => DebtTile(
                    transaction: ledger.open[index],
                    formats: formats,
                    onTap: () => _showDetails(context, ledger.open[index]),
                  ),
                ),
              ),
            ],
            if (ledger.history.isNotEmpty) ...[
              _SectionHeader(strings.settledHistory),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverList.builder(
                  itemCount: ledger.history.length,
                  itemBuilder: (context, index) => _SettledGroupTile(
                    group: ledger.history[index],
                    formats: formats,
                    onTap: (t) => _showDetails(context, t),
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ],
      ),
    );
  }

  Future<void> _addTransaction(BuildContext context) {
    final cubit = context.read<PersonLedgerCubit>();
    return DebtTransactionSheet.show(
      context,
      onSave:
          ({
            required personId,
            required amountText,
            required type,
            required date,
            note,
          }) => cubit.addTransaction(
            amountText: amountText,
            type: type,
            date: date,
            note: note,
          ),
    );
  }

  Future<void> _showDetails(
    BuildContext context,
    PersonTransaction transaction,
  ) async {
    final cubit = context.read<PersonLedgerCubit>();
    final formats = context.read<SettingsCubit>().state.formats;
    final action = await DebtDetailsSheet.show(
      context,
      transaction: transaction,
      formats: formats,
    );
    if (!context.mounted) return;
    switch (action) {
      case DebtDetailsAction.edit:
        await DebtTransactionSheet.show(
          context,
          existing: transaction,
          onSave:
              ({
                required personId,
                required amountText,
                required type,
                required date,
                note,
              }) => cubit.editTransaction(
                transaction,
                amountText: amountText,
                type: type,
                date: date,
                note: note,
              ),
        );
      case DebtDetailsAction.delete:
        final strings = context.strings;
        final confirmed = await _confirm(
          context,
          title: strings.deleteTransactionTitle,
          body: strings.deleteTransactionBody,
          action: strings.delete,
          destructive: true,
        );
        if (confirmed) await cubit.deleteTransaction(transaction);
      case null:
        break;
    }
  }

  Future<void> _editPerson(BuildContext context) {
    final cubit = context.read<PersonLedgerCubit>();
    return PersonEditorSheet.show(
      context,
      existing: ledger.person,
      onSave: cubit.editPerson,
    );
  }

  Future<void> _deletePerson(BuildContext context) async {
    final strings = context.strings;
    final peopleCubit = context.read<PeopleCubit>();
    final navigator = Navigator.of(context);
    final confirmed = await _confirm(
      context,
      title: strings.deletePersonTitle(ledger.person.name),
      body: strings.deletePersonBody,
      action: strings.delete,
      destructive: true,
    );
    if (!confirmed) return;
    // The People tab reports the delete once this page is gone.
    navigator.pop();
    await peopleCubit.deletePerson(ledger.person);
  }

  /// Confirms the amount, settles, then offers to log the money that changed
  /// hands in the monthly budget.
  Future<void> _settle(BuildContext context, AppFormats formats) async {
    final strings = context.strings;
    final cubit = context.read<PersonLedgerCubit>();
    final homeCubit = context.read<HomeCubit>();
    final name = ledger.person.name;
    final balance = ledger.balance;
    final amount = formats.money(balance.magnitude);

    final confirmed = await _confirm(
      context,
      title: strings.settleTitle(name),
      body: [
        switch (balance.direction) {
          DebtDirection.owedToMe => strings.settleTheyPay(name, amount),
          DebtDirection.iOwe => strings.settleYouPay(name, amount),
          DebtDirection.settled => strings.settleEven,
        },
        strings.settleMoves(ledger.open.length),
      ].join('\n\n'),
      action: strings.settle,
    );
    if (!confirmed || !context.mounted) return;

    final settlement = await cubit.settleUp();
    final type = settlement?.budgetType;
    if (settlement == null || type == null || !context.mounted) return;

    final log = await _confirm(
      context,
      title: strings.logSettlementTitle,
      body: switch (type) {
        TransactionType.income => strings.logSettlementIncome(amount),
        TransactionType.expense => strings.logSettlementExpense(amount),
      },
      action: strings.yes,
      cancel: strings.no,
    );
    if (!log) return;
    final logged = await cubit.logToBudget(
      settlement,
      description: strings.settlementNote(name),
    );
    // The home screen, its budget and the analyses follow the new
    // transaction.
    if (logged) await homeCubit.refresh();
  }

  static Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String body,
    required String action,
    String? cancel,
    bool destructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancel ?? dialogContext.strings.cancel),
          ),
          TextButton(
            style: destructive
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(dialogContext).colorScheme.error,
                  )
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(action),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

/// Where the user stands with the person, and the way to settle it.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.ledger,
    required this.formats,
    required this.onSettle,
  });

  final PersonLedger ledger;
  final AppFormats formats;
  final VoidCallback onSettle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final balance = ledger.balance;
    final color = debtColor(context, balance.direction);
    final phone = ledger.person.phone;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PersonAvatar(person: ledger.person, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debtStandingWith(
                          strings,
                          balance.direction,
                          ledger.person.name,
                        ),
                        style: theme.textTheme.titleMedium,
                      ),
                      if (phone != null)
                        Text(
                          phone,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              formats.money(balance.magnitude),
              style: theme.textTheme.displaySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (ledger.canSettle) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onSettle,
                icon: const Icon(Icons.handshake_outlined),
                label: Text(
                  balance.isSettled
                      ? strings.settleUp
                      : strings.settleUpFor(formats.money(balance.magnitude)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
    sliver: SliverToBoxAdapter(
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// One settle-up in the history: when, how much and which way, opening to
/// the transactions it cleared.
class _SettledGroupTile extends StatelessWidget {
  const _SettledGroupTile({
    required this.group,
    required this.formats,
    required this.onTap,
  });

  final SettledGroup group;
  final AppFormats formats;
  final ValueChanged<PersonTransaction> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final settlement = group.settlement;

    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: const EdgeInsetsDirectional.only(start: 12, end: 12),
      leading: Icon(
        Icons.task_alt_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        strings.settledGroupTitle(formats.fullDate(settlement.settledAt)),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        [
          _direction(strings, settlement),
          strings.transactionCount(group.transactions.length),
          if (settlement.isLoggedToBudget) strings.loggedInBudget,
        ].join(' · '),
      ),
      trailing: Text(
        formats.money(settlement.balance.magnitude),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        for (final transaction in group.transactions)
          DebtTile(
            transaction: transaction,
            formats: formats,
            onTap: () => onTap(transaction),
          ),
      ],
    );
  }

  static String _direction(AppStrings strings, Settlement settlement) =>
      switch (settlement.balance.direction) {
        DebtDirection.owedToMe => strings.theyPaidYou,
        DebtDirection.iOwe => strings.youPaidThem,
        DebtDirection.settled => strings.settledUp,
      };
}

class _EmptyLedger extends StatelessWidget {
  const _EmptyLedger();

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
              Icons.swap_horiz_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              strings.noDebtsYet,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.noDebtsHint,
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
