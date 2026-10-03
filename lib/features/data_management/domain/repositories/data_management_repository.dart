import '../../../../core/error/api_result.dart';
import '../entities/backup_preview.dart';
import '../entities/export_format.dart';
import '../entities/export_locale.dart';
import '../entities/exported_file.dart';
import '../entities/import_mode.dart';
import '../entities/share_anchor.dart';

/// How far a running export or import has got, from 0 to 1.
typedef DataProgress = void Function(double fraction);

/// Files the user keeps themselves: exports to share or save, and backups to
/// import. Works offline, signed in or not.
abstract interface class DataManagementRepository {
  /// Writes every record in [format] to temporary storage.
  Future<ApiResult<List<ExportedFile>>> export(
    ExportFormat format,
    ExportLocale locale, {
    DataProgress? onProgress,
  });

  /// Opens the system share sheet: WhatsApp, email, Drive, Files and so on.
  Future<ApiResult<void>> share(
    List<ExportedFile> files, {
    ShareAnchor? anchor,
  });

  /// Asks the system where to save each file. Succeeds with false when the
  /// user cancels.
  Future<ApiResult<bool>> saveToDevice(List<ExportedFile> files);

  /// Asks the system for a file. Succeeds with null when the user cancels.
  Future<ApiResult<String?>> pickFile();

  /// Reads and checks a backup without changing anything.
  Future<ApiResult<BackupPreview>> previewBackup(String path);

  /// Checks the backup again, then applies it in a single transaction.
  /// Returns how many records changed.
  Future<ApiResult<int>> importBackup(
    String path,
    ImportMode mode, {
    DataProgress? onProgress,
  });
}
