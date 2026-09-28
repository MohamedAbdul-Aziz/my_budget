import '../../../../core/error/api_result.dart';
import '../entities/export_format.dart';
import '../entities/export_locale.dart';
import '../entities/exported_file.dart';
import '../repositories/data_management_repository.dart';

/// Exports every record: a restorable backup, spreadsheets or a report.
class ExportData {
  const ExportData(this._repository);

  final DataManagementRepository _repository;

  Future<ApiResult<List<ExportedFile>>> call(
    ExportFormat format,
    ExportLocale locale, {
    DataProgress? onProgress,
  }) => _repository.export(format, locale, onProgress: onProgress);
}
