import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/backup_preview.dart';
import '../repositories/data_management_repository.dart';

/// Checks text the user pasted, such as an AI chat's reply to the import
/// prompt, the same way as a chosen backup file. Changes nothing yet.
class PreviewPastedBackup {
  const PreviewPastedBackup(this._repository);

  final DataManagementRepository _repository;

  Future<ApiResult<BackupPreview>> call(String text) async {
    if (text.trim().isEmpty) {
      return const ResultFailure(
        FileFailure(FailureCode.pastedNotRecognized, 'nothing pasted'),
      );
    }
    final result = await _repository.previewText(text);
    // "Not a backup file" would puzzle someone who pasted a chat reply.
    return switch (result) {
      ResultFailure(
        failure: FileFailure(
          code: FailureCode.backupNotRecognized || FailureCode.backupDamaged,
          :final debugMessage,
        ),
      ) =>
        ResultFailure(
          FileFailure(FailureCode.pastedNotRecognized, debugMessage),
        ),
      _ => result,
    };
  }
}
