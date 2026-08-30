import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../expenses/presentation/cubit/home_cubit.dart';
import '../../../expenses/presentation/cubit/home_state.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/cubit/settings_state.dart';
import '../publish_widget.dart';

/// Keeps the home screen widget in step with the running app.
///
/// Widget taps do not come through here — they open the quick-add activity
/// directly. This only republishes the widget's contents when the data or the
/// user's language and currency change, and picks up expenses that the
/// quick-add dialog added while the app was in the background.
class QuickExpenseBridge extends StatefulWidget {
  const QuickExpenseBridge({super.key, required this.child});

  final Widget child;

  @override
  State<QuickExpenseBridge> createState() => _QuickExpenseBridgeState();
}

class _QuickExpenseBridgeState extends State<QuickExpenseBridge> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // The quick-add dialog writes to the same database from its own engine,
    // so the app reloads the month whenever it comes back to the foreground.
    _lifecycle = AppLifecycleListener(onResume: sl<HomeCubit>().refresh);
    // Publish once at startup so a freshly placed widget fills in even if
    // nothing has changed since the last run.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => publishQuickExpenseWidget(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Any change to the month's expenses.
        BlocListener<HomeCubit, HomeState>(
          listener: (_, _) => publishQuickExpenseWidget(),
        ),
        // Language or currency changed, so the widget's text must change too.
        BlocListener<SettingsCubit, SettingsState>(
          listener: (_, _) => publishQuickExpenseWidget(),
        ),
      ],
      child: widget.child,
    );
  }
}
