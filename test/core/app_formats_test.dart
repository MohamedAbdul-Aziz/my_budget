import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_budget/core/utils/app_formats.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

void main() {
  setUpAll(initializeDateFormatting);

  group('English', () {
    AppFormats formats() =>
        AppFormats(localeName: 'en_US', currencySymbol: r'$');

    test('labels the month', () {
      expect(formats().monthLabel(const Month(2026, 8)), 'August 2026');
    });

    test('drops the cents on a round total', () {
      expect(formats().moneyTight(25), r'$25');
      expect(formats().moneyTight(25.5), r'$25.50');
      expect(formats().money(25), r'$25.00');
    });
  });

  group('Arabic', () {
    test('names months and weekdays in Arabic', () {
      final formats = AppFormats(localeName: 'ar');
      expect(formats.monthLabel(const Month(2026, 8)), contains('أغسطس'));
      expect(formats.dayLabel(DateTime(2026, 8, 4)), contains('الثلاثاء'));
    });

    test('puts the currency symbol where Arabic expects it', () {
      final formats = AppFormats(localeName: 'ar', currencySymbol: 'ج.م');
      expect(formats.symbol, 'ج.م');
      expect(formats.moneyTight(25), endsWith('ج.م'));
    });
  });

  test('an unknown locale falls back instead of throwing', () {
    final formats = AppFormats(localeName: 'zz_ZZ', currencySymbol: r'$');
    expect(formats.monthLabel(const Month(2026, 8)), 'August 2026');
  });

  group('day comparisons', () {
    test('counts days back from today', () {
      final now = DateTime(2026, 8, 27, 10);
      expect(AppFormats.daysAgo(DateTime(2026, 8, 27, 23), now: now), 0);
      expect(AppFormats.daysAgo(DateTime(2026, 8, 26, 1), now: now), 1);
      expect(AppFormats.daysAgo(DateTime(2026, 8, 20), now: now), 7);
    });

    test('ignores the time of day', () {
      expect(
        AppFormats.isSameDay(DateTime(2026, 8, 4, 1), DateTime(2026, 8, 4, 23)),
        isTrue,
      );
      expect(
        AppFormats.isSameDay(DateTime(2026, 8, 4), DateTime(2026, 8, 5)),
        isFalse,
      );
    });
  });
}
