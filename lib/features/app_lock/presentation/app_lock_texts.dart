import '../../../core/l10n/app_strings.dart';
import '../domain/entities/app_lock_prompt.dart';

/// The phone's prompt when opening the locked app.
AppLockPrompt unlockPrompt(AppStrings strings) => AppLockPrompt(
  reason: strings.unlockToContinue,
  title: strings.appTitle,
  cancel: strings.cancel,
);

/// The phone's prompt when turning the lock on or off.
AppLockPrompt changeLockPrompt(AppStrings strings) => AppLockPrompt(
  reason: strings.confirmItsYou,
  title: strings.appLock,
  cancel: strings.cancel,
);
