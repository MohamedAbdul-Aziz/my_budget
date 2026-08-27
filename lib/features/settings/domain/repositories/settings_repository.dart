import '../../../../core/error/api_result.dart';
import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<ApiResult<AppSettings>> loadSettings();

  Future<ApiResult<AppSettings>> saveThemeMode(AppThemeMode mode);

  Future<ApiResult<AppSettings>> saveLanguage(AppLanguage language);

  Future<ApiResult<AppSettings>> saveCurrencySymbol(String symbol);
}
