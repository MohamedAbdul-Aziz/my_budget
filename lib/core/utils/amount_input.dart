import 'package:flutter/services.dart';

/// Money typed on the numeric keypad: what an amount field accepts, and how
/// the typed text becomes a number.
abstract final class AmountInput {
  /// Digits and either decimal separator, at most 12 characters.
  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
    LengthLimitingTextInputFormatter(12),
  ];

  /// Accepts both `1,50` and `1.50` so the numeric keypad works in every
  /// locale. Returns null when the text is not a usable amount.
  static double? parse(String text) {
    final cleaned = text.trim().replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null || value.isNaN || value.isInfinite) return null;
    return double.parse(value.toStringAsFixed(2));
  }

  /// `12` or `12.50`: an amount the way it would be typed, for pre-filling a
  /// field.
  static String editable(double amount) => amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
}
