import '../../../../core/error/api_result.dart';
import '../entities/app_lock_prompt.dart';
import '../entities/app_lock_status.dart';
import '../repositories/app_lock_repository.dart';

/// Turns the lock on or off, only after the phone confirms it is the owner:
/// otherwise anyone holding an unlocked phone could switch it off.
class SetAppLock {
  const SetAppLock(this._repository);

  final AppLockRepository _repository;

  /// The status afterwards: unchanged when the prompt was cancelled.
  Future<ApiResult<AppLockStatus>> call(
    AppLockStatus current, {
    required bool enabled,
    required AppLockPrompt prompt,
  }) async {
    if (!current.supported || !current.available) return Success(current);

    switch (await _repository.authenticate(prompt)) {
      case ResultFailure(:final failure):
        return ResultFailure(failure);
      case Success(data: false):
        return Success(current);
      case Success():
        break;
    }
    return (await _repository.setEnabled(
      enabled: enabled,
    )).map((_) => current.copyWith(enabled: enabled));
  }
}
