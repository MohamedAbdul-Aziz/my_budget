import '../../../../core/error/api_result.dart';
import '../entities/assistant_sharing.dart';
import '../repositories/assistant_repository.dart';

class GetAssistantSharing {
  const GetAssistantSharing(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<AssistantSharing>> call() => _repository.getSharing();
}
