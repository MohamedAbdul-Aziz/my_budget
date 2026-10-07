import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../../core/utils/category_icons.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../expenses/domain/entities/category_breakdown.dart';

/// A category's icon over its share, drawn on its slice of a [DonutChart],
/// so the ring reads without looking down at the list.
class CategorySliceLabel extends StatelessWidget {
  const CategorySliceLabel(this.item, this.formats, {super.key});

  final CategoryBreakdown item;
  final AppFormats formats;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: categoryLabel(context.strings, item.category),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CategoryIcons.resolve(item.category.iconName),
            size: 18,
            color: Colors.white,
          ),
          Text(
            formats.percent(item.share),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
