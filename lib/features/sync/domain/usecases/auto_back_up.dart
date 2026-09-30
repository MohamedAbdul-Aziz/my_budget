import '../../../../core/error/api_result.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/sync_report.dart';
import '../repositories/sync_repository.dart';

/// A backup the app starts on its own, when leaving the app or opening it.
///
/// Runs only if the user turned automatic backup on for this phone, someone
/// is signed in, and there is something new to upload, so most calls never
/// touch the network. Succeeds with null when it had no reason to run.
class AutoBackUp {
  const AutoBackUp({
    required SyncRepository syncRepository,
    required AuthRepository authRepository,
  }) : _sync = syncRepository,
       _auth = authRepository;

  final SyncRepository _sync;
  final AuthRepository _auth;

  Future<ApiResult<SyncReport?>> call({SyncProgress? onProgress}) async {
    if (_auth.currentUser == null) return const Success(null);

    switch (await _sync.autoBackupEnabled()) {
      case ResultFailure(:final failure):
        return ResultFailure(failure);
      case Success(data: false):
        return const Success(null);
      case Success():
        break;
    }
    switch (await _sync.hasPendingChanges()) {
      case ResultFailure(:final failure):
        return ResultFailure(failure);
      case Success(data: false):
        return const Success(null);
      case Success():
        break;
    }
    return _sync.backUp(onProgress: onProgress);
  }
}
