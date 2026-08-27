import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/utils/app_formats.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/load_settings.dart';
import '../../domain/usecases/save_currency_symbol.dart';
import '../../domain/usecases/save_language.dart';
import '../../domain/usecases/save_theme_mode.dart';
import 'settings_state.dart';

/// Owns theme, language and currency formatting for the whole app.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required LoadSettings loadSettings,
    required SaveThemeMode saveThemeMode,
    required SaveLanguage saveLanguage,
    required SaveCurrencySymbol saveCurrencySymbol,
  }) : _loadSettings = loadSettings,
       _saveThemeMode = saveThemeMode,
       _saveLanguage = saveLanguage,
       _saveCurrencySymbol = saveCurrencySymbol,
       super(SettingsState.initial());

  final LoadSettings _loadSettings;
  final SaveThemeMode _saveThemeMode;
  final SaveLanguage _saveLanguage;
  final SaveCurrencySymbol _saveCurrencySymbol;

  /// [localeName] comes from the platform (e.g. `en_US` or `ar_EG`) and is used
  /// whenever the language preference is "system".
  Future<void> load({String? localeName}) async {
    final systemLocale = localeName ?? state.systemLocaleName;
    _apply(await _loadSettings(), systemLocaleName: systemLocale);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (mode == state.settings.themeMode) return;
    _apply(await _saveThemeMode(mode));
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (language == state.settings.language) return;
    _apply(await _saveLanguage(language));
  }

  Future<void> setCurrencySymbol(String symbol) async =>
      _apply(await _saveCurrencySymbol(symbol));

  void _apply(ApiResult<AppSettings> result, {String? systemLocaleName}) {
    final systemLocale = systemLocaleName ?? state.systemLocaleName;
    // A failed read or write leaves the current settings in place — the app
    // stays usable, it just keeps the previous preference.
    final settings = result.dataOrNull ?? state.settings;
    emit(
      SettingsState(
        settings: settings,
        formats: AppFormats(
          localeName: formatsLocaleFor(settings.language, systemLocale),
          currencySymbol: settings.currencySymbol,
        ),
        systemLocaleName: systemLocale,
      ),
    );
  }

  /// Numbers and dates follow the language actually being displayed. A device
  /// locale the app does not translate falls back to English formatting too,
  /// so the screen never mixes two conventions.
  static String formatsLocaleFor(AppLanguage language, String systemLocale) =>
      switch (language) {
        AppLanguage.english => 'en_US',
        AppLanguage.arabic => 'ar',
        AppLanguage.system when systemLocale.startsWith('ar') => systemLocale,
        AppLanguage.system when systemLocale.startsWith('en') => systemLocale,
        AppLanguage.system => 'en_US',
      };
}
