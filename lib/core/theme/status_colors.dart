import 'package:flutter/material.dart';

/// Colors that say how something stands: fine, needs attention, or bad.
///
/// Each one stays readable as text on the app's surfaces (at least 4.5:1) in
/// its theme, so it can color a label as well as a bar or a dot.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.good,
    required this.caution,
    required this.danger,
  });

  static const StatusColors light = StatusColors(
    good: Color(0xFF2E7D32),
    caution: Color(0xFFB35C00),
    danger: Color(0xFFC62828),
  );

  static const StatusColors dark = StatusColors(
    good: Color(0xFF81C784),
    caution: Color(0xFFFFB74D),
    danger: Color(0xFFEF9A9A),
  );

  final Color good;
  final Color caution;
  final Color danger;

  /// The colors registered on the current theme.
  static StatusColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<StatusColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  @override
  StatusColors copyWith({Color? good, Color? caution, Color? danger}) =>
      StatusColors(
        good: good ?? this.good,
        caution: caution ?? this.caution,
        danger: danger ?? this.danger,
      );

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      good: Color.lerp(good, other.good, t)!,
      caution: Color.lerp(caution, other.caution, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}
