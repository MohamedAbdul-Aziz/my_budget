import 'package:equatable/equatable.dart';

/// Framework-free mirror of Flutter's ThemeMode; the presentation layer maps it.
enum AppThemeMode { system, light, dark }

/// The languages the app ships with. `system` follows the device.
enum AppLanguage { system, english, arabic }

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.system,
    this.currencySymbol,
  });

  final AppThemeMode themeMode;
  final AppLanguage language;

  /// `null` means "follow the locale".
  final String? currencySymbol;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    String? currencySymbol,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
    currencySymbol: currencySymbol ?? this.currencySymbol,
  );

  @override
  List<Object?> get props => [themeMode, language, currencySymbol];
}
