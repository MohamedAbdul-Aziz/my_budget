import 'package:equatable/equatable.dart';

/// The language and number formats an export is written in, so a CSV or PDF
/// reads the way the app does.
class ExportLocale extends Equatable {
  const ExportLocale({
    required this.languageCode,
    required this.formatsLocale,
    required this.currencySymbol,
  });

  /// `en` or `ar`: the language of headings and labels.
  final String languageCode;

  /// The locale that numbers and dates are formatted in.
  final String formatsLocale;

  final String currencySymbol;

  bool get isRightToLeft => languageCode == 'ar';

  @override
  List<Object?> get props => [languageCode, formatsLocale, currencySymbol];
}
