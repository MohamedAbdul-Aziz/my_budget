import '../../../../core/database/device_settings.dart';
import '../../../../core/error/api_result.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/entities/spending_summary.dart';
import '../../domain/repositories/assistant_repository.dart';
import '../datasources/assistant_remote_data_source.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  const AssistantRepositoryImpl({
    required AssistantRemoteDataSource remote,
    required DeviceSettings deviceSettings,
  }) : _remote = remote,
       _deviceSettings = deviceSettings;

  final AssistantRemoteDataSource _remote;
  final DeviceSettings _deviceSettings;

  @override
  Future<ApiResult<String>> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
  }) => ApiResult.guard(
    () => _remote.ask(
      question: question,
      summary: summary,
      history: history,
      languageCode: languageCode,
    ),
  );

  @override
  Future<ApiResult<bool>> hasConsent() =>
      ApiResult.guard(() => _deviceSettings.readFlag(DeviceSettings.aiConsent));

  @override
  Future<ApiResult<void>> setConsent({required bool granted}) =>
      ApiResult.guard(
        () => _deviceSettings.writeFlag(DeviceSettings.aiConsent, on: granted),
      );
}
