import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_strings.dart';
import '../../analyses/presentation/cubit/analyses_cubit.dart';
import '../../analyses/presentation/pages/analyses_page.dart';
import '../../expenses/presentation/cubit/home_cubit.dart';
import '../../expenses/presentation/pages/home_page.dart';

/// The two top-level screens behind a bottom navigation bar. Both stay alive
/// in an [IndexedStack], so switching tabs keeps scroll positions.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// Local UI state: the selected tab.
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // The home screen has already loaded by the time this is built, so the
    // app-level listener that keeps analyses in step has no change to react
    // to yet. Load the first analysis here.
    context.read<AnalysesCubit>().load(context.read<HomeCubit>().selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          // The hidden tab's animations (spinners) stop until it is shown.
          TickerMode(enabled: _index == 0, child: const HomePage()),
          TickerMode(enabled: _index == 1, child: const AnalysesPage()),
        ],
      ),
      floatingActionButton: _index == 0 ? const AddExpenseButton() : null,
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
        ],
      ),
    );
  }
}
