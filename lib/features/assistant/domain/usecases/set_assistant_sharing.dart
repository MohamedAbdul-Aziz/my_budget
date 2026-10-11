import '../../../../core/error/api_result.dart';
import '../entities/assistant_sharing.dart';
import '../repositories/assistant_repository.dart';

/// Saves what the assistant may see, on this phone only.
class SetAssistantSharing {
  const SetAssistantSharing(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<void>> call(AssistantSharing sharing) =>
      _repository.setSharing(sharing);
}
