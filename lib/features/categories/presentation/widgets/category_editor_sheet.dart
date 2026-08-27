import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/category_icons.dart';
import '../../domain/usecases/create_category.dart';
import '../category_label.dart';
import '../../domain/entities/expense_category.dart';

/// What the sheet hands back to its caller.
typedef CategoryDraft = ({String name, String iconName, int colorValue});

/// Create or rename a category, pick its icon and color.
class CategoryEditorSheet extends StatefulWidget {
  const CategoryEditorSheet({super.key, this.existing});

  final ExpenseCategory? existing;

  /// Returns the draft, or null when dismissed.
  static Future<CategoryDraft?> show(
    BuildContext context, {
    ExpenseCategory? existing,
  }) => showModalBottomSheet<CategoryDraft>(
    context: context,
    isScrollControlled: true,
    builder: (_) => CategoryEditorSheet(existing: existing),
  );

  @override
  State<CategoryEditorSheet> createState() => _CategoryEditorSheetState();
}

class _CategoryEditorSheetState extends State<CategoryEditorSheet> {
  // Controllers belong to the State, never to build().
  late final TextEditingController _nameController;
  late final FocusNode _nameFocus;
  late String _iconName;
  late int _colorValue;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameFocus = FocusNode();
    _iconName = widget.existing?.iconName ?? CategoryIcons.fallbackName;
    _colorValue = widget.existing?.colorValue ?? CategoryColors.defaultColor;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A built-in category shows its translated name, which is only available
    // once localizations are in scope.
    final existing = widget.existing;
    if (existing != null && _nameController.text.isEmpty) {
      _nameController.text = categoryLabel(context.strings, existing);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(
        () => _error = context.strings.failure(
          FailureCode.categoryNameRequired,
        ),
      );
      _nameFocus.requestFocus();
      return;
    }
    Navigator.of(context).pop((
      name: name,
      iconName: _iconName,
      colorValue: _colorValue,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final isEditing = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? strings.editCategory : strings.newCategory,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              autofocus: !isEditing,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              maxLength: CreateCategory.maxNameLength,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: strings.categoryName,
                counterText: '',
                errorText: _error,
                prefixIcon: Icon(
                  CategoryIcons.resolve(_iconName),
                  color: Color(_colorValue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionLabel(strings.color),
            _ColorRow(
              selected: _colorValue,
              onSelected: (value) => setState(() => _colorValue = value),
            ),
            const SizedBox(height: 16),
            _SectionLabel(strings.icon),
            _IconGrid(
              selected: _iconName,
              color: Color(_colorValue),
              onSelected: (name) => setState(() => _iconName = name),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submit,
              child: Text(
                isEditing ? strings.saveChanges : strings.addCategory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CategoryColors.palette.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final value = CategoryColors.palette[index];
          final isSelected = value == selected;
          return GestureDetector(
            onTap: () => onSelected(value),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(value),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 3,
                      )
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _IconGrid extends StatelessWidget {
  const _IconGrid({
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  final String selected;
  final Color color;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final names = CategoryIcons.names;
    return SizedBox(
      height: 200,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: names.length,
        itemBuilder: (context, index) {
          final name = names[index];
          final isSelected = name == selected;
          return InkWell(
            onTap: () => onSelected(name),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.18)
                    : Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
                border: isSelected ? Border.all(color: color, width: 2) : null,
              ),
              child: Icon(
                CategoryIcons.resolve(name),
                size: 22,
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        },
      ),
    );
  }
}
