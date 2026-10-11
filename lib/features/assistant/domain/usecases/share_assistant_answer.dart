import '../../../../core/error/api_result.dart';
import '../../../data_management/domain/entities/share_anchor.dart';
import '../repositories/assistant_repository.dart';

/// Hands an answer to the phone's share sheet, as plain text.
class ShareAssistantAnswer {
  const ShareAssistantAnswer(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<void>> call(String text, {ShareAnchor? anchor}) =>
      _repository.shareText(text, anchor: anchor);
}
