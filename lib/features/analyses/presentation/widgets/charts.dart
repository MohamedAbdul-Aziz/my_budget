import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One slice of a [DonutChart].
typedef DonutSlice = ({double value, Color color});

/// A ring split into slices, drawn without a chart package.
class DonutChart extends StatelessWidget {
  const DonutChart({super.key, required this.slices, this.size = 160});

  final List<DonutSlice> slices;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _DonutPainter(
          slices,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.slices, this.trackColor);

  final List<DonutSlice> slices;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.16;
    final rect =
        Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = trackColor);

    final total = slices.fold<double>(0, (sum, slice) => sum + slice.value);
    if (total <= 0) return;

    // A hairline gap between slices keeps neighbours with close colours apart.
    final gap = slices.length > 1 ? 0.02 : 0.0;
    var start = -math.pi / 2;
    for (final slice in slices) {
      final sweep = slice.value / total * math.pi * 2;
      canvas.drawArc(
        rect,
        start + gap / 2,
        math.max(sweep - gap, 0.001),
        false,
        paint..color = slice.color,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.slices != slices || old.trackColor != trackColor;
}

/// One bar of a [BarChart].
typedef Bar = ({String label, double value, bool highlighted});

/// Vertical bars with a label under each. Follows the reading direction, so
/// in Arabic the oldest bar sits on the right.
class BarChart extends StatelessWidget {
  const BarChart({super.key, required this.bars, this.height = 140});

  final List<Bar> bars;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highest = bars.fold<double>(
      0,
      (max, bar) => math.max(max, bar.value),
    );

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final bar in bars)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: highest == 0
                            ? 0
                            : math.max(bar.value / highest, 0.02),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: bar.highlighted
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withValues(
                                    alpha: 0.35,
                                  ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bar.label,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: bar.highlighted ? FontWeight.w700 : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One group of a [GroupedBarChart]: the same thing measured twice.
typedef BarPair = ({Widget label, double first, double second});

/// Pairs of bars side by side, e.g. each category in two months. The first
/// bar of a pair is drawn solid and the second faded, matching [legend].
class GroupedBarChart extends StatelessWidget {
  const GroupedBarChart({
    super.key,
    required this.pairs,
    required this.legend,
    this.height = 150,
  });

  final List<BarPair> pairs;

  /// What the solid and the faded bars stand for.
  final (String, String) legend;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final solid = theme.colorScheme.primary;
    final faded = theme.colorScheme.primary.withValues(alpha: 0.35);
    final highest = pairs.fold<double>(
      0,
      (max, pair) => math.max(max, math.max(pair.first, pair.second)),
    );

    Widget bar(double value, Color color) => Expanded(
      child: FractionallySizedBox(
        alignment: Alignment.bottomCenter,
        heightFactor: highest == 0 || value == 0
            ? 0
            : math.max(value / highest, 0.02),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );

    Widget key(Color color, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall,
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final pair in pairs)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              bar(pair.first, solid),
                              const SizedBox(width: 2),
                              bar(pair.second, faded),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        pair.label,
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [key(solid, legend.$1), key(faded, legend.$2)],
        ),
      ],
    );
  }
}
