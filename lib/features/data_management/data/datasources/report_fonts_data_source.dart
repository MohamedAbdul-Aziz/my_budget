import 'dart:typed_data';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart' show rootBundle;

import '../../../../core/error/failures.dart';

/// A regular and a bold cut of one font.
typedef FontPair = ({Uint8List regular, Uint8List bold});

/// The fonts one report is typeset in.
///
/// [arabic] is set when [main] has no Arabic: the PDF layout only joins
/// Arabic within a single font, so text with Arabic letters in it (a category
/// name, a note) is set wholly in that font instead of letter by letter.
typedef ReportFonts = ({FontPair main, FontPair? arabic});

/// The fonts embedded in PDF reports, both from IBM Plex (SIL Open Font
/// License, see `assets/pdf_fonts/OFL.txt`):
///
/// - IBM Plex Sans Arabic: Latin plus every Arabic, Persian and Urdu
///   presentation form the PDF layout draws joined Arabic with. Fonts missing
///   those forms print broken letters.
/// - IBM Plex Sans: Latin Extended (Turkish, Polish, Vietnamese…) and
///   Cyrillic, which the Arabic cut lacks.
///
/// Nothing is bundled for Chinese, Japanese or Korean: those fonts would add
/// many megabytes to the app, so reports fall back to English instead.
abstract interface class ReportFontsDataSource {
  /// Whether a bundled font draws [languageCode]'s script.
  bool supports(String languageCode);

  /// The fonts for [languageCode], or for English when it is unsupported.
  Future<ReportFonts> load(String languageCode);
}

class ReportFontsDataSourceImpl implements ReportFontsDataSource {
  const ReportFontsDataSourceImpl();

  static const String _folder = 'assets/pdf_fonts';

  /// Written in IBM Plex Sans Arabic, which English reports have always used.
  static const Set<String> _arabicFontLanguages = {'en', 'ar', 'fa', 'ur'};

  static const Set<String> _latinFontLanguages = {
    'es',
    'fr',
    'pt',
    'ru',
    'de',
    'tr',
    'id',
    'it',
    'vi',
    'pl',
    'nl',
    'uk',
    'ms',
  };

  @override
  bool supports(String languageCode) =>
      _arabicFontLanguages.contains(languageCode) ||
      _latinFontLanguages.contains(languageCode);

  @override
  Future<ReportFonts> load(String languageCode) async {
    try {
      final arabic = await _pair('IBMPlexSansArabic');
      if (!_latinFontLanguages.contains(languageCode)) {
        return (main: arabic, arabic: null);
      }
      return (main: await _pair('IBMPlexSans'), arabic: arabic);
    } on FlutterError catch (error) {
      throw FileFailure(FailureCode.exportFailed, 'report font: $error');
    }
  }

  Future<FontPair> _pair(String family) async => (
    regular: await _file('$family-Regular'),
    bold: await _file('$family-Bold'),
  );

  Future<Uint8List> _file(String name) async {
    final data = await rootBundle.load('$_folder/$name.ttf');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
