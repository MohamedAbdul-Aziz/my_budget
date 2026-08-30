import 'dart:convert';

import '../../domain/entities/quick_expense_snapshot.dart';

/// Serializes a snapshot into the JSON the Android widget parses.
///
/// Colors travel as `#AARRGGBB` strings so Kotlin can use `Color.parseColor`
/// without worrying about Dart's unsigned 32-bit color ints.
abstract final class QuickExpensePayload {
  static String encode(QuickExpenseSnapshot snapshot) => jsonEncode({
    'title': snapshot.title,
    'monthLabel': snapshot.monthLabel,
    'total': snapshot.total,
    'addLabel': snapshot.addLabel,
    'categories': [
      for (final shortcut in snapshot.categories)
        {
          'id': shortcut.categoryId,
          'name': shortcut.name,
          'color': encodeColor(shortcut.colorValue),
        },
    ],
  });

  static String encodeColor(int argb) =>
      '#${(argb & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
