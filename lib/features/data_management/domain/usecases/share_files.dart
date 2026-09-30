import '../../../../core/error/api_result.dart';
import '../entities/exported_file.dart';
import '../entities/share_anchor.dart';
import '../repositories/data_management_repository.dart';

class ShareFiles {
  const ShareFiles(this._repository);

  final DataManagementRepository _repository;

  Future<ApiResult<void>> call(
    List<ExportedFile> files, {
    ShareAnchor? anchor,
  }) => _repository.share(files, anchor: anchor);
}
