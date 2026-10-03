import 'package:flutter/material.dart';

import '../../../../core/theme/status_colors.dart';
import '../../domain/entities/budget_line.dart';
import '../budget_level_color.dart';

/// How much of a limit is used, as a bar that fills from the reading start:
/// left to right in English, right to left in Arabic.
///
/// Its length and its color both animate, so logging an expense visibly
/// moves the bar, and crossing 70% or 90% fades it to the next color.
class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({super.key, required this.line, this.height = 10});

  final BudgetLine line;
  final double height;

  static const Duration _duration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    final target = line.level.colorIn(StatusColors.of(context));
    // Past the limit the bar is simply full; the red says the rest.
    final fill = line.fraction.clamp(0.0, 1.0);

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: target),
      duration: _duration,
      builder: (context, color, _) => TweenAnimationBuilder<double>(
        // Grows in from empty the first time it appears.
        tween: Tween(begin: 0, end: fill),
        duration: _duration,
        curve: Curves.easeOutCubic,
        builder: (context, value, _) =>
            _Track(fill: value, color: color ?? target, height: height),
      ),
    );
  }
}

class _Track extends StatelessWidget {
  const _Track({required this.fill, required this.color, required this.height});

  final double fill;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ColoredBox(
          color: color.withValues(alpha: 0.18),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: fill,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color, borderRadius: radius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
