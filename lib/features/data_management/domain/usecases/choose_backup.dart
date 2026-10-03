import '../../../../core/error/api_result.dart';
import '../entities/backup_preview.dart';
import '../repositories/data_management_repository.dart';

/// Lets the user pick a backup file and checks it, changing nothing yet.
/// Succeeds with null when they cancel the picker.
class ChooseBackup {
  const ChooseBackup(this._repository);

  final DataManagementRepository _repository;

  Future<ApiResult<BackupPreview?>> call() async {
    final picked = await _repository.pickFile();
    return switch (picked) {
      ResultFailure(:final failure) => ResultFailure(failure),
      Success(data: null) => const Success(null),
      Success(data: final path?) => await _repository.previewBackup(path),
    };
  }
}
