import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/features/quick_expense/data/models/quick_expense_payload.dart';
import 'package:my_budget/features/quick_expense/domain/entities/quick_expense_snapshot.dart';

void main() {
  test('encodes colors the way Color.parseColor expects', () {
    // Dart colors are unsigned; Android needs #AARRGGBB.
    expect(QuickExpensePayload.encodeColor(0xFFEF6C00), '#FFEF6C00');
    expect(QuickExpensePayload.encodeColor(0x00000000), '#00000000');
    expect(QuickExpensePayload.encodeColor(0xFFFFFFFF), '#FFFFFFFF');
  });

  test('hands the widget finished, already-translated text', () {
    const snapshot = QuickExpenseSnapshot(
      title: 'مصروف سريع',
      monthLabel: 'أغسطس 2026',
      total: '١٢٣ ج.م',
      addLabel: 'إضافة مصروف',
      categories: [
        QuickExpenseShortcut(
          categoryId: 'cat_food',
          name: 'طعام',
          colorValue: 0xFFEF6C00,
        ),
      ],
    );

    final decoded =
        jsonDecode(QuickExpensePayload.encode(snapshot))
            as Map<String, Object?>;

    expect(decoded['title'], 'مصروف سريع');
    expect(decoded['monthLabel'], 'أغسطس 2026');
    expect(decoded['total'], '١٢٣ ج.م');
    expect(decoded['addLabel'], 'إضافة مصروف');
    expect(decoded['categories'], [
      {'id': 'cat_food', 'name': 'طعام', 'color': '#FFEF6C00'},
    ]);
  });
}
