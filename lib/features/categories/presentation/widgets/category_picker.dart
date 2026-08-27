import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/category_icons.dart';
import '../category_label.dart';
import '../../domain/entities/expense_category.dart';

/// Horizontal-wrapping category chips used by the expense form.
///
/// Every category is visible at once, so choosing one is a single tap.
class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    this.onCreate,
  });

  final List<ExpenseCategory> categories;
  final String? selectedId;
  final ValueChanged<ExpenseCategory> onSelected;

  /// Shows a trailing "New" chip when provided.
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in categories)
          _CategoryChip(
            category: category,
            selected: category.id == selectedId,
            onTap: () => onSelected(category),
          ),
        if (onCreate != null)
          ActionChip(
            avatar: const Icon(Icons.add_rounded, size: 18),
            label: Text(context.strings.newCategory),
            onPressed: onCreate,
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ExpenseCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      avatar: Icon(
        CategoryIcons.resolve(category.iconName),
        size: 18,
        color: selected ? Colors.white : color,
      ),
      label: Text(categoryLabel(context.strings, category)),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: selected ? Colors.white : null,
      ),
      selectedColor: color,
      backgroundColor: color.withValues(alpha: 0.10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}
