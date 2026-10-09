/// The currencies offered in Settings: an ISO code (its name comes from
/// `AppStrings.currencyName`) and the symbol shown next to every amount.
/// Anything else goes in through "Other". Every symbol fits
/// `SaveCurrencySymbol.maxSymbolLength`.
///
/// `E£`, `TL` and `Rial` are what the phone's locale gives by default in
/// Arabic, Turkish and Persian, so they are listed next to the local
/// symbols: someone who never chose a symbol finds theirs selected rather
/// than "Other".
const List<({String code, String symbol})> currencyChoices = [
  (code: 'EGP', symbol: 'ج.م'),
  (code: 'EGP', symbol: 'E£'),
  (code: 'USD', symbol: r'$'),
  (code: 'EUR', symbol: '€'),
  (code: 'SAR', symbol: 'ر.س'),
  (code: 'AED', symbol: 'د.إ'),
  (code: 'KWD', symbol: 'د.ك'),
  (code: 'QAR', symbol: 'ر.ق'),
  (code: 'BHD', symbol: 'د.ب'),
  (code: 'OMR', symbol: 'ر.ع'),
  (code: 'JOD', symbol: 'د.أ'),
  (code: 'IQD', symbol: 'د.ع'),
  (code: 'LBP', symbol: 'ل.ل'),
  (code: 'SYP', symbol: 'ل.س'),
  (code: 'YER', symbol: 'ر.ي'),
  (code: 'SDG', symbol: 'ج.س'),
  (code: 'LYD', symbol: 'ل.د'),
  (code: 'MAD', symbol: 'د.م.'),
  (code: 'TND', symbol: 'د.ت'),
  (code: 'DZD', symbol: 'د.ج'),
  (code: 'GBP', symbol: '£'),
  (code: 'TRY', symbol: '₺'),
  (code: 'TRY', symbol: 'TL'),
  (code: 'IRR', symbol: '﷼'),
  (code: 'IRR', symbol: 'Rial'),
  (code: 'PKR', symbol: 'Rs'),
  (code: 'INR', symbol: '₹'),
  (code: 'RUB', symbol: '₽'),
  (code: 'UAH', symbol: '₴'),
  (code: 'PLN', symbol: 'zł'),
  (code: 'CHF', symbol: 'CHF'),
  (code: 'BRL', symbol: r'R$'),
  (code: 'CAD', symbol: r'C$'),
  (code: 'AUD', symbol: r'A$'),
  (code: 'CNY', symbol: '¥'),
  (code: 'JPY', symbol: '¥'),
  (code: 'KRW', symbol: '₩'),
  (code: 'IDR', symbol: 'Rp'),
  (code: 'MYR', symbol: 'RM'),
  (code: 'VND', symbol: '₫'),
  (code: 'NGN', symbol: '₦'),
];

/// The first choice using [symbol]; null for a symbol the list lacks.
({String code, String symbol})? currencyChoiceFor(String symbol) {
  for (final choice in currencyChoices) {
    if (choice.symbol == symbol) return choice;
  }
  return null;
}

/// The flag of the country an ISO 4217 code belongs to: its first two
/// letters are that country's code (`EU` for the euro), drawn as the two
/// regional-indicator letters every phone renders as a flag.
String currencyFlag(String code) => String.fromCharCodes([
  for (final letter in code.substring(0, 2).codeUnits) 0x1F1E6 + letter - 0x41,
]);
