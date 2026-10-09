import '../../../../core/error/api_result.dart';
import '../repositories/assistant_repository.dart';

class GetAssistantConsent {
  const GetAssistantConsent(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<bool>> call() => _repository.hasConsent();
}
