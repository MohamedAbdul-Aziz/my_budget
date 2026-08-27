import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

void main() {
  group('Month', () {
    test('builds a zero-padded sortable key', () {
      expect(const Month(2026, 8).key, '2026-08');
      expect(const Month(2026, 12).key, '2026-12');
    });

    test('round-trips through its key', () {
      expect(Month.fromKey('2026-03'), const Month(2026, 3));
    });

    test('rolls over the year at both edges', () {
      expect(const Month(2026, 1).previous, const Month(2025, 12));
      expect(const Month(2026, 12).next, const Month(2027, 1));
    });

    test('sorts chronologically', () {
      final months = [
        const Month(2026, 1),
        const Month(2025, 12),
        const Month(2026, 3),
      ]..sort();
      expect(months, [
        const Month(2025, 12),
        const Month(2026, 1),
        const Month(2026, 3),
      ]);
    });

    test('spans exactly one month', () {
      const month = Month(2026, 2);
      expect(month.start, DateTime(2026, 2));
      expect(month.endExclusive, DateTime(2026, 3));
      expect(month.contains(DateTime(2026, 2, 28)), isTrue);
      expect(month.contains(DateTime(2026, 3)), isFalse);
    });
  });
}
