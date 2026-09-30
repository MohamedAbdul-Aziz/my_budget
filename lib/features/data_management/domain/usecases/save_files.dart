import '../../../../core/error/api_result.dart';
import '../entities/exported_file.dart';
import '../repositories/data_management_repository.dart';

/// Saves exported files wherever the user picks. Succeeds with false when
/// they cancel.
class SaveFiles {
  const SaveFiles(this._repository);

  final DataManagementRepository _repository;

  Future<ApiResult<bool>> call(List<ExportedFile> files) =>
      _repository.saveToDevice(files);
}
