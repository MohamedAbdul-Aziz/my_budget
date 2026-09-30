import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/utils/ui_notice.dart';
import '../../analyses/presentation/cubit/analyses_cubit.dart';
import '../../analyses/presentation/pages/analyses_page.dart';
import '../../expenses/presentation/cubit/home_cubit.dart';
import '../../expenses/presentation/pages/home_page.dart';
import '../../people/presentation/cubit/people_cubit.dart';
import '../../people/presentation/pages/people_page.dart';
import '../../recurring/presentation/cubit/recurring_cubit.dart';
import '../../recurring/presentation/cubit/recurring_state.dart';

/// The top-level screens behind a bottom navigation bar. All stay alive
/// in an [IndexedStack], so switching tabs keeps scroll positions.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// Local UI state: the selected tab.
  int _index = 0;

  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // The home screen has already loaded by the time this is built, so the
    // app-level listener that keeps analyses in step has no change to react
    // to yet. Load the first analysis here.
    context.read<AnalysesCubit>().load(context.read<HomeCubit>().selectedMonth);
    // Not needed for the first frame, which shows the home tab.
    context.read<PeopleCubit>().load();

    final recurring = context.read<RecurringCubit>();
    // Back in the foreground, possibly on a later day: log what fell due
    // and let a reminder turn overdue.
    _lifecycle = AppLifecycleListener(onResume: recurring.refresh);
    // Payments logged automatically while starting up were logged before
    // this listened, so their notice is shown here.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showRecurringNotice(context, recurring.state);
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  /// Recurring payments are marked paid from the home screen and from their
  /// own page, so their notices are shown from here, above both. Snackbars
  /// appear on whichever screen is on top.
  static void _showRecurringNotice(BuildContext context, RecurringState state) {
    if (state is! RecurringReady) return;
    final notice = state.notice;
    if (notice == null) return;
    final strings = context.strings;
    // Undo belongs to the paid notice only.
    final canUndo =
        state.canUndoPayment && notice.code == NoticeCode.recurringPaid;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(strings.notice(notice)),
          action: canUndo
              ? SnackBarAction(
                  label: strings.undo,
                  onPressed: context.read<RecurringCubit>().undoPayment,
                )
              : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocListener<RecurringCubit, RecurringState>(
      listenWhen: (previous, current) =>
          current is RecurringReady && current.notice != null,
      listener: _showRecurringNotice,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            // The hidden tab's animations (spinners) stop until it is shown.
            TickerMode(enabled: _index == 0, child: const HomePage()),
            TickerMode(enabled: _index == 1, child: const AnalysesPage()),
            TickerMode(enabled: _index == 2, child: const PeoplePage()),
          ],
        ),
        floatingActionButton: switch (_index) {
          0 => const AddExpenseButton(),
          2 => const AddPeopleButton(),
          _ => null,
        },
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() => _index = index),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: strings.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.insights_outlined),
              selectedIcon: const Icon(Icons.insights_rounded),
              label: strings.analyses,
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline_rounded),
              selectedIcon: const Icon(Icons.people_rounded),
              label: strings.people,
            ),
          ],
        ),
      ),
    );
  }
}
