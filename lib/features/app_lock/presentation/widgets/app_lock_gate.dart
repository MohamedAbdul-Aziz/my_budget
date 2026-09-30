import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../app_lock_texts.dart';
import '../cubit/app_lock_cubit.dart';
import '../cubit/app_lock_state.dart';

/// Covers the whole app, open sheets and dialogs included, with the lock
/// screen while the app is locked, and asks the phone to unlock it.
///
/// Sits above the navigator, so the lock screen cannot be popped away.
class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> {
  late final AppLifecycleListener _lifecycle;

  /// Locked while the app was still coming back: the phone's prompt can only
  /// show once it is fully in front.
  bool _promptOnResume = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AppLockCubit>();
    _lifecycle = AppLifecycleListener(
      onHide: cubit.noteHidden,
      onShow: cubit.noteShown,
      onResume: () {
        if (!_promptOnResume) return;
        _promptOnResume = false;
        _prompt();
      },
    );
    // Opened locked: ask straight away.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && cubit.state is AppLockLocked) _promptWhenInFront();
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _promptWhenInFront() {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle == null || lifecycle == AppLifecycleState.resumed) {
      _prompt();
    } else {
      _promptOnResume = true;
    }
  }

  void _prompt() {
    if (!mounted) return;
    context.read<AppLockCubit>().unlock(unlockPrompt(context.strings));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLockCubit, AppLockState>(
      listenWhen: (previous, current) =>
          current is AppLockLocked && previous is! AppLockLocked,
      listener: (context, _) => _promptWhenInFront(),
      buildWhen: (previous, current) =>
          current is AppLockLocked || previous is AppLockLocked,
      builder: (context, state) {
        final locked = state is AppLockLocked;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Nothing underneath keeps the keyboard or reads out to a screen
            // reader while locked.
            ExcludeFocus(
              excluding: locked,
              child: ExcludeSemantics(excluding: locked, child: widget.child),
            ),
            if (state case AppLockLocked(:final checking))
              _LockScreen(checking: checking, onUnlock: _prompt),
          ],
        );
      },
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.checking, required this.onUnlock});

  final bool checking;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    // Above the navigator, so it brings its own Material.
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  strings.appTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.unlockToContinue,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  icon: const Icon(Icons.fingerprint_rounded),
                  label: Text(strings.unlock),
                  onPressed: checking ? null : onUnlock,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
