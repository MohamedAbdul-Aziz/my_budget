import '../../../../core/error/api_result.dart';
import '../entities/assistant_chat.dart';
import '../repositories/assistant_repository.dart';

class GetAssistantChats {
  const GetAssistantChats(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<List<AssistantChat>>> call() => _repository.getChats();
}
