import 'package:flutter/material.dart';

import '../../../../core/utils/category_icons.dart';
import '../../domain/entities/expense_category.dart';

/// The tinted circle that identifies a category everywhere in the app.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.category,
    this.size = 44,
    this.filled = false,
  });

  final ExpenseCategory category;
  final double size;

  /// Solid color instead of a tint — used for the selected picker item.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: Icon(
        CategoryIcons.resolve(category.iconName),
        size: size * 0.5,
        color: filled ? Colors.white : color,
      ),
    );
  }
}
