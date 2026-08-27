import '../../../../core/error/api_result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class SaveThemeMode {
  const SaveThemeMode(this._repository);

  final SettingsRepository _repository;

  Future<ApiResult<AppSettings>> call(AppThemeMode mode) =>
      _repository.saveThemeMode(mode);
}
