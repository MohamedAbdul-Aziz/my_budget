import '../../../../core/error/api_result.dart';
import '../repositories/assistant_repository.dart';

/// Records, on this phone only, whether the user agrees to send their
/// summary out. It can be withdrawn at any time.
class SetAssistantConsent {
  const SetAssistantConsent(this._repository);

  final AssistantRepository _repository;

  Future<ApiResult<void>> call({required bool granted}) =>
      _repository.setConsent(granted: granted);
}
