import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../domain/entities/app_lock_prompt.dart';
import '../../domain/entities/app_lock_status.dart';
import '../../domain/usecases/get_app_lock.dart';
import '../../domain/usecases/set_app_lock.dart';
import '../../domain/usecases/unlock_app.dart';
import 'app_lock_state.dart';

/// Locks the app at launch and after it was away for a while, and opens it
/// once the phone confirms the owner. Every call that may show the phone's
/// prompt takes its words in the current language.
class AppLockCubit extends Cubit<AppLockState> {
  AppLockCubit({
    required GetAppLock getAppLock,
    required SetAppLock setAppLock,
    required UnlockApp unlockApp,
    DateTime Function()? clock,
  }) : _getAppLock = getAppLock,
       _setAppLock = setAppLock,
       _unlockApp = unlockApp,
       _clock = clock ?? DateTime.now,
       super(const AppLockLoading());

  /// Long enough to pick a file, share an export or answer a quick message
  /// without being asked again; short enough that a phone left on a table
  /// is locked.
  static const Duration gracePeriod = Duration(minutes: 1);

  final GetAppLock _getAppLock;
  final SetAppLock _setAppLock;
  final UnlockApp _unlockApp;
  final DateTime Function() _clock;

  DateTime? _hiddenAt;

  /// At launch: with the lock on, the app opens locked.
  Future<void> load() async {
    final status = switch (await _getAppLock()) {
      Success(:final data) => data,
      // Unreadable: never lock the owner out of their own data.
      ResultFailure() => const AppLockStatus.off(),
    };
    emit(status.isOn ? AppLockLocked(status) : AppLockOpen(status));
  }

  /// The app went to the background.
  void noteHidden() {
    if (state is AppLockOpen) _hiddenAt = _clock();
  }

  /// The app came back: locked if it was away for [gracePeriod] or longer.
  void noteShown() {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (hiddenAt == null) return;
    if (state case AppLockOpen(
      :final status,
    ) when status.isOn && _clock().difference(hiddenAt) >= gracePeriod) {
      emit(AppLockLocked(status));
    }
  }

  Future<void> unlock(AppLockPrompt prompt) async {
    if (state case AppLockLocked(:final status, checking: false)) {
      emit(AppLockLocked(status, checking: true));
      final opened = switch (await _unlockApp(prompt)) {
        Success(:final data) => data,
        ResultFailure() => false,
      };
      emit(opened ? AppLockOpen(status) : AppLockLocked(status));
    }
  }

  /// Turning the lock on or off asks the phone first.
  Future<void> setEnabled(bool enabled, AppLockPrompt prompt) async {
    if (state case AppLockOpen(:final status)) {
      final result = await _setAppLock(
        status,
        enabled: enabled,
        prompt: prompt,
      );
      emit(switch (result) {
        Success(:final data) => AppLockOpen(data),
        ResultFailure(:final failure) => AppLockOpen(
          status,
          error: failure.code,
        ),
      });
    }
  }
}
