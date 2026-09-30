import '../../../../core/error/api_result.dart';
import '../entities/app_lock_prompt.dart';
import '../repositories/app_lock_repository.dart';

/// Opens the locked app once the phone confirms it is the owner.
class UnlockApp {
  const UnlockApp(this._repository);

  final AppLockRepository _repository;

  Future<ApiResult<bool>> call(AppLockPrompt prompt) async {
    // The screen lock was removed since: nothing to check against, and the
    // owner must never be locked out of their own data.
    switch (await _repository.isAvailable()) {
      case Success(data: false):
        return const Success(true);
      case ResultFailure(:final failure):
        return ResultFailure(failure);
      case Success():
        break;
    }
    return _repository.authenticate(prompt);
  }
}
