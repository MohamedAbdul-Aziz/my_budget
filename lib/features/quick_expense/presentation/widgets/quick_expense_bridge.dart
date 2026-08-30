import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../expenses/presentation/cubit/home_cubit.dart';
import '../../../expenses/presentation/cubit/home_state.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/cubit/settings_state.dart';
import '../../domain/entities/quick_add_request.dart';
import '../../domain/usecases/consume_quick_add_launch.dart';
import '../../domain/usecases/watch_quick_add_requests.dart';
import '../pages/quick_add_sheet.dart';
import '../quick_expense_widget_sync.dart';

/// Connects the Android home screen widget to the running app.
///
/// It does two things: opens the quick-add sheet when the widget is tapped,
/// and republishes the widget's contents whenever the data or the user's
/// language and currency change.
class QuickExpenseBridge extends StatefulWidget {
  const QuickExpenseBridge({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  /// The sheet and its snackbars need a context below the Navigator.
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<QuickExpenseBridge> createState() => _QuickExpenseBridgeState();
}

class _QuickExpenseBridgeState extends State<QuickExpenseBridge> {
  StreamSubscription<QuickAddRequest>? _subscription;

  /// Guards against a second tap stacking another sheet on the first.
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    _subscription = sl<WatchQuickAddRequests>()().listen(_openSheet);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleLaunch());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _handleLaunch() async {
    // Publish once at startup so a freshly placed widget fills in even if
    // nothing has changed since the last run.
    await _publish();
    final request = await sl<ConsumeQuickAddLaunch>()();
    if (request != null) await _openSheet(request);
  }

  Future<void> _openSheet(QuickAddRequest request) async {
    final context = widget.navigatorKey.currentContext;
    if (_sheetOpen || context == null || !context.mounted) return;

    _sheetOpen = true;
    final saved = await QuickAddSheet.show(
      context,
      categoryId: request.categoryId,
    );
    _sheetOpen = false;

    if (saved ?? false) {
      // Refreshing the month also republishes the widget, via the listener.
      await sl<HomeCubit>().refresh();
      _confirmSaved();
    }
  }

  void _confirmSaved() {
    final context = widget.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(AppStrings.of(context).expenseSaved)));
  }

  /// Reads the language from settings rather than from the widget tree: the
  /// listener fires as the state changes, before the tree has rebuilt with the
  /// new locale, so `AppStrings.of(context)` would still be the old language.
  Future<void> _publish() async {
    final settings = sl<SettingsCubit>().state;
    await sl<QuickExpenseWidgetSync>().refresh(
      strings: AppStrings.forLanguageCode(settings.languageCode),
      formats: settings.formats,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Any change to the month's expenses.
        BlocListener<HomeCubit, HomeState>(
          listener: (_, _) => _publish(),
        ),
        // Language or currency changed, so the widget's text must change too.
        BlocListener<SettingsCubit, SettingsState>(
          listener: (_, _) => _publish(),
        ),
      ],
      child: widget.child,
    );
  }
}
