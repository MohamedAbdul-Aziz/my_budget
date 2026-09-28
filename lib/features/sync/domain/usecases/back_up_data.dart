import '../../../../core/error/api_result.dart';
import '../entities/sync_report.dart';
import '../repositories/sync_repository.dart';

class BackUpData {
  const BackUpData(this._repository);

  final SyncRepository _repository;

  Future<ApiResult<SyncReport>> call({SyncProgress? onProgress}) =>
      _repository.backUp(onProgress: onProgress);
}
