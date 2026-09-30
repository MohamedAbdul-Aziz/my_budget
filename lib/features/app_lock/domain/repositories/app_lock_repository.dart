import '../../../../core/error/api_result.dart';
import '../entities/app_lock_prompt.dart';

abstract interface class AppLockRepository {
  /// Whether this platform offers the lock at all.
  bool get isSupported;

  /// Whether the phone has a screen lock or biometrics to check against.
  Future<ApiResult<bool>> isAvailable();

  /// A preference of this phone alone, never synced: a restore must never
  /// lock a phone that has no screen lock.
  Future<ApiResult<bool>> isEnabled();

  Future<ApiResult<void>> setEnabled({required bool enabled});

  /// Shows the phone's prompt; true once the user proved it is them. A
  /// cancelled or failed prompt is false, not a failure.
  Future<ApiResult<bool>> authenticate(AppLockPrompt prompt);
}
