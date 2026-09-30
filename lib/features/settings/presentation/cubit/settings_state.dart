import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Locale, ThemeMode;

import '../../../../core/utils/app_formats.dart';
import '../../domain/entities/app_settings.dart';

/// Always holds a usable value — defaults apply until the stored settings load.
class SettingsState extends Equatable {
  const SettingsState({
    required this.settings,
    required this.formats,
    required this.systemLocaleName,
  });

  factory SettingsState.initial({String systemLocaleName = 'en_US'}) =>
      SettingsState(
        settings: const AppSettings(),
        formats: AppFormats(localeName: systemLocaleName),
        systemLocaleName: systemLocaleName,
      );

  final AppSettings settings;

  /// Numbers and dates for the active language. Rebuilt only when the
  /// language or the currency symbol changes.
  final AppFormats formats;

  /// The device locale, used when the language is set to "system".
  final String systemLocaleName;

  ThemeMode get themeMode => switch (settings.themeMode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  /// `null` lets MaterialApp resolve the locale from the device.
  Locale? get locale => switch (settings.language.languageCode) {
    final code? => Locale(code),
    null => null,
  };

  /// The device's language, when the app translates it.
  AppLanguage? get deviceLanguage => AppLanguage.fromCode(systemLocaleName);

  /// What the language picker offers: the device setting, English, and the
  /// device's own language. Anything else chosen earlier stays listed so the
  /// current choice never disappears from the picker.
  List<AppLanguage> get pickerLanguages {
    final device = deviceLanguage;
    return [
      AppLanguage.system,
      AppLanguage.english,
      if (device != null && device != AppLanguage.english) device,
      if (!{
        AppLanguage.system,
        AppLanguage.english,
        device,
      }.contains(settings.language))
        settings.language,
    ];
  }

  /// The language actually being displayed, for code that cannot read it from
  /// the widget tree — an unsupported device locale resolves to English.
  String get languageCode =>
      locale?.languageCode ?? systemLocaleName.split(RegExp('[_-]')).first;

  @override
  List<Object?> get props => [settings, formats, systemLocaleName];
}
