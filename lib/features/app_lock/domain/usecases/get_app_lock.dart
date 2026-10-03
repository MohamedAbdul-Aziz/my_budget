import '../../../../core/error/api_result.dart';
import '../entities/app_lock_status.dart';
import '../repositories/app_lock_repository.dart';

class GetAppLock {
  const GetAppLock(this._repository);

  final AppLockRepository _repository;

  Future<ApiResult<AppLockStatus>> call() async {
    if (!_repository.isSupported) return const Success(AppLockStatus.off());

    final bool available;
    switch (await _repository.isAvailable()) {
      case Success(:final data):
        available = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }
    return (await _repository.isEnabled()).map(
      (enabled) => AppLockStatus(
        supported: true,
        available: available,
        enabled: enabled,
      ),
    );
  }
}
