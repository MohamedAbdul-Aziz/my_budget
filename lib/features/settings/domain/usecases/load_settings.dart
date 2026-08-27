import '../../../../core/error/api_result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class LoadSettings {
  const LoadSettings(this._repository);

  final SettingsRepository _repository;

  Future<ApiResult<AppSettings>> call() => _repository.loadSettings();
}
