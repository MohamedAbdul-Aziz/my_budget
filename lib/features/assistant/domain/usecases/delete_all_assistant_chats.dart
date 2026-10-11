import '../../../../core/error/api_result.dart';
import '../repositories/assistant_repository.dart';

class DeleteAllAssistantChats {
  const DeleteAllAssistantChats(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<void>> call() => _repository.deleteAllChats();
}
