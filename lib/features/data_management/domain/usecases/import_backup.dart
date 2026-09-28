import '../../../../core/error/api_result.dart';
import '../entities/backup_preview.dart';
import '../entities/import_mode.dart';
import '../repositories/data_management_repository.dart';

/// Applies a backup the user has already seen and confirmed. Returns how
/// many records changed.
class ImportBackup {
  const ImportBackup(this._repository);

  final DataManagementRepository _repository;

  Future<ApiResult<int>> call(
    BackupPreview backup,
    ImportMode mode, {
    DataProgress? onProgress,
  }) => _repository.importBackup(backup.path, mode, onProgress: onProgress);
}
