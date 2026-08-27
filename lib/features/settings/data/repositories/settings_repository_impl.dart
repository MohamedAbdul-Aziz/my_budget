import '../../../../core/error/api_result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _currencyKey = 'currency_symbol';

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<ApiResult<AppSettings>> loadSettings() =>
      ApiResult.guard(() async => _parse(await _localDataSource.readAll()));

  @override
  Future<ApiResult<AppSettings>> saveThemeMode(AppThemeMode mode) =>
      _write(_themeKey, mode.name);

  @override
  Future<ApiResult<AppSettings>> saveLanguage(AppLanguage language) =>
      _write(_languageKey, language.name);

  @override
  Future<ApiResult<AppSettings>> saveCurrencySymbol(String symbol) =>
      _write(_currencyKey, symbol);

  /// Persists one preference and returns the whole settings object, so callers
  /// never hold a half-updated copy.
  Future<ApiResult<AppSettings>> _write(String key, String value) =>
      ApiResult.guard(() async {
        await _localDataSource.write(key, value);
        return _parse(await _localDataSource.readAll());
      });

  AppSettings _parse(Map<String, String> values) => AppSettings(
    themeMode: _enumOr(AppThemeMode.values, values[_themeKey], AppThemeMode.system),
    language: _enumOr(AppLanguage.values, values[_languageKey], AppLanguage.system),
    currencySymbol: values[_currencyKey],
  );

  /// Unknown or missing values fall back to the default rather than throwing.
  T _enumOr<T extends Enum>(List<T> values, String? name, T fallback) =>
      values.firstWhere((value) => value.name == name, orElse: () => fallback);
}
