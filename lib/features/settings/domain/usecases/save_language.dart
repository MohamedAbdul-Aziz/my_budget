import '../../../../core/error/api_result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class SaveLanguage {
  const SaveLanguage(this._repository);

  final SettingsRepository _repository;

  Future<ApiResult<AppSettings>> call(AppLanguage language) =>
      _repository.saveLanguage(language);
}
