import '../../../../core/error/api_result.dart';
import '../repositories/sync_repository.dart';

class GetAutoBackup {
  const GetAutoBackup(this._repository);

  final SyncRepository _repository;

  Future<ApiResult<bool>> call() => _repository.autoBackupEnabled();
}
