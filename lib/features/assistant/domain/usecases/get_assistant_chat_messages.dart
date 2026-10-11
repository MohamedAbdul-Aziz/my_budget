import '../../../../core/error/api_result.dart';
import '../entities/assistant_message.dart';
import '../repositories/assistant_repository.dart';

class GetAssistantChatMessages {
  const GetAssistantChatMessages(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<List<AssistantMessage>>> call(String chatId) =>
      _repository.getMessages(chatId);
}
