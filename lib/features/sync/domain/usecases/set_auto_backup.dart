import '../../../../core/error/api_result.dart';
import '../repositories/sync_repository.dart';

class SetAutoBackup {
  const SetAutoBackup(this._repository);

  final SyncRepository _repository;

  Future<ApiResult<void>> call({required bool enabled}) =>
      _repository.setAutoBackup(enabled: enabled);
}
