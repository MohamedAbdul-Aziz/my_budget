import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/widgets/settings_sheet.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/month.dart';
import '../../domain/entities/month_overview.dart';
import '../../domain/entities/monthly_summary.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/expense_tile.dart';
import '../widgets/month_picker_sheet.dart';
import '../widgets/month_total_card.dart';
import 'expense_form_page.dart';

/// The month at a glance: what it cost, where it went, and what was spent.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: const _MonthTitleButton(),
        actions: [
          IconButton(
            tooltip: strings.categories,
            icon: const Icon(Icons.label_outline_rounded),
            onPressed: () => Navigator.of(context).push(CategoriesPage.route()),
          ),
          IconButton(
            tooltip: strings.settings,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => SettingsSheet.show(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(strings.add),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            current is HomeReady && current.notice != null,
        listener: (context, state) {
          final ready = state as HomeReady;
          final notice = ready.notice!;
          // Undo belongs to the delete notice only — a later error snackbar
          // must not offer to restore an unrelated expense.
          final canUndo =
              ready.canUndoDelete && notice.code == NoticeCode.expenseDeleted;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(context.strings.notice(notice)),
                action: canUndo
                    ? SnackBarAction(
                        label: context.strings.undo,
                        onPressed: context.read<HomeCubit>().undoDelete,
                      )
                    : null,
              ),
            );
        },
        builder: (context, state) => switch (state) {
          HomeLoading() => const Center(child: CircularProgressIndicator()),
          HomeLoadFailure(:final failure) => _LoadFailure(
            message: strings.failure(failure.code),
          ),
          HomeReady(:final overview) => _MonthView(overview: overview),
        },
      ),
    );
  }

  /// Opens the add/edit screen and refreshes the month if something was saved.
  static Future<void> _openForm(
    BuildContext context, {
    Expense? existing,
  }) async {
    final cubit = context.read<HomeCubit>();
    final saved = await Navigator.of(
      context,
    ).push(ExpenseFormPage.route(existing: existing));
    if (saved ?? false) await cubit.refresh();
  }
}

/// Tapping the month name opens the month switcher.
class _MonthTitleButton extends StatelessWidget {
  const _MonthTitleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous is! HomeReady ||
          current is! HomeReady ||
          previous.month != current.month ||
          previous.months != current.months,
      builder: (context, state) {
        final (month, months) = switch (state) {
          HomeReady(:final month, :final months) => (month, months),
          _ => (Month.current(), const <MonthlySummary>[]),
        };
        final formats = context.select<SettingsCubit, AppFormats>(
          (cubit) => cubit.state.formats,
        );

        return TextButton.icon(
          onPressed: () => _pickMonth(
            context,
            month: month,
            months: months,
            formats: formats,
          ),
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.expand_more_rounded),
          label: Text(
            formats.monthLabel(month),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }

  Future<void> _pickMonth(
    BuildContext context, {
    required Month month,
    required List<MonthlySummary> months,
    required AppFormats formats,
  }) async {
    final cubit = context.read<HomeCubit>();
    final picked = await MonthPickerSheet.show(
      context,
      months: months,
      selected: month,
      formats: formats,
    );
    if (picked != null) await cubit.selectMonth(picked);
  }
}

class _MonthView extends StatelessWidget {
  const _MonthView({required this.overview});

  final MonthOverview overview;

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when the language or currency changes.
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().refresh,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: MonthTotalCard(overview: overview, formats: formats),
            ),
          ),
          if (overview.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyMonth(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
              sliver: _ExpenseSliver(
                expenses: overview.expenses,
                formats: formats,
              ),
            ),
        ],
      ),
    );
  }
}

/// The month's expenses, newest first, with a small header whenever the day
/// changes. The comparison is O(1) per row, so nothing is precomputed.
class _ExpenseSliver extends StatelessWidget {
  const _ExpenseSliver({required this.expenses, required this.formats});

  final List<Expense> expenses;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final startsNewDay =
            index == 0 ||
            !AppFormats.isSameDay(expenses[index - 1].date, expense.date);

        final tile = ExpenseTile(
          expense: expense,
          formats: formats,
          onTap: () => HomePage._openForm(context, existing: expense),
          onDismissed: () => context.read<HomeCubit>().remove(expense),
        );

        if (!startsNewDay) return tile;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_DayHeader(date: expense.date, formats: formats), tile],
        );
      },
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.date, required this.formats});

  final DateTime date;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
    child: Text(
      context.strings.dayLabel(date, formats),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _EmptyMonth extends StatelessWidget {
  const _EmptyMonth();

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
              Icons.receipt_long_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              strings.nothingRecordedYet,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.emptyMonthHint,
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
              onPressed: () => context.read<HomeCubit>().load(),
              child: Text(context.strings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
