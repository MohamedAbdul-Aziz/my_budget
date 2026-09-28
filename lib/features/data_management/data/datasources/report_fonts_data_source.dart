import 'dart:typed_data';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart' show rootBundle;

import '../../../../core/error/failures.dart';

/// The font embedded in PDF reports: IBM Plex Sans Arabic (SIL Open Font
/// License, see `assets/pdf_fonts/OFL.txt`). One font with both Latin and
/// every Arabic presentation form the PDF layout draws joined Arabic with:
/// fonts missing those forms print broken letters, and mixing two fonts
/// makes the layout order mixed-direction text wrongly.
abstract interface class ReportFontsDataSource {
  Future<({Uint8List regular, Uint8List bold})> load();
}

class ReportFontsDataSourceImpl implements ReportFontsDataSource {
  const ReportFontsDataSourceImpl();

  static const String _folder = 'assets/pdf_fonts';

  @override
  Future<({Uint8List regular, Uint8List bold})> load() async {
    try {
      final regular = await rootBundle.load(
        '$_folder/IBMPlexSansArabic-Regular.ttf',
      );
      final bold = await rootBundle.load('$_folder/IBMPlexSansArabic-Bold.ttf');
      return (
        regular: regular.buffer.asUint8List(
          regular.offsetInBytes,
          regular.lengthInBytes,
        ),
        bold: bold.buffer.asUint8List(bold.offsetInBytes, bold.lengthInBytes),
      );
    } on FlutterError catch (error) {
      throw FileFailure(FailureCode.exportFailed, 'report font: $error');
    }
  }
}
