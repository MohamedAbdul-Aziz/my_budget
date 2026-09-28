import '../../../../core/error/api_result.dart';
import '../repositories/sync_repository.dart';

class GetLastSyncedAt {
  const GetLastSyncedAt(this._repository);

  final SyncRepository _repository;

  Future<ApiResult<DateTime?>> call() => _repository.lastSyncedAt();
}
