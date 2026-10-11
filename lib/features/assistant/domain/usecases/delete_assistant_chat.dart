import '../../../../core/error/api_result.dart';
import '../repositories/assistant_repository.dart';

class DeleteAssistantChat {
  const DeleteAssistantChat(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<void>> call(String chatId) => _repository.deleteChat(chatId);
}
