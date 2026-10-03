import 'package:equatable/equatable.dart';

/// Framework-free mirror of Flutter's ThemeMode; the presentation layer maps it.
enum AppThemeMode { system, light, dark }

/// The languages the app ships with. `system` follows the device.
///
/// Stored by [name], so an existing value is never renamed: an older app
/// version reads a name it does not know as [system].
enum AppLanguage {
  system(null, ''),
  english('en', 'English'),
  arabic('ar', 'العربية', rightToLeft: true),
  chinese('zh', '中文'),
  spanish('es', 'Español'),
  french('fr', 'Français'),
  portuguese('pt', 'Português'),
  russian('ru', 'Русский'),
  german('de', 'Deutsch'),
  japanese('ja', '日本語'),
  korean('ko', '한국어'),
  turkish('tr', 'Türkçe'),
  indonesian('id', 'Bahasa Indonesia'),
  italian('it', 'Italiano'),
  persian('fa', 'فارسی', rightToLeft: true),
  urdu('ur', 'اردو', rightToLeft: true),
  vietnamese('vi', 'Tiếng Việt'),
  polish('pl', 'Polski'),
  dutch('nl', 'Nederlands'),
  ukrainian('uk', 'Українська'),
  malay('ms', 'Bahasa Melayu');

  const AppLanguage(
    this.languageCode,
    this.nativeName, {
    this.rightToLeft = false,
  });

  /// ISO 639-1 code; null for [system].
  final String? languageCode;

  /// The language's name written in itself, so it is readable whatever
  /// language the app is currently in.
  final String nativeName;
  final bool rightToLeft;

  /// Every language except [system].
  static Iterable<AppLanguage> get translated =>
      values.where((language) => language != system);

  /// The translated language for a code such as `fr` or `fr_CA`, or null.
  static AppLanguage? fromCode(String? code) {
    final language = code?.split(RegExp('[_-]')).first.toLowerCase();
    for (final candidate in translated) {
      if (candidate.languageCode == language) return candidate;
    }
    return null;
  }
}

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
