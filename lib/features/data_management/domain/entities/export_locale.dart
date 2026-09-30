import 'package:equatable/equatable.dart';

import '../../../settings/domain/entities/app_settings.dart';

/// The language and number formats an export is written in, so a CSV or PDF
/// reads the way the app does.
class ExportLocale extends Equatable {
  const ExportLocale({
    required this.languageCode,
    required this.formatsLocale,
    required this.currencySymbol,
  });

  /// The language of headings and labels, such as `en` or `ar`.
  final String languageCode;

  /// The locale that numbers and dates are formatted in.
  final String formatsLocale;

  final String currencySymbol;

  bool get isRightToLeft =>
      AppLanguage.fromCode(languageCode)?.rightToLeft ?? false;

  /// The same export written in English, keeping the currency symbol.
  ExportLocale get inEnglish => ExportLocale(
    languageCode: 'en',
    formatsLocale: 'en_US',
    currencySymbol: currencySymbol,
  );

  @override
  List<Object?> get props => [languageCode, formatsLocale, currencySymbol];
}
