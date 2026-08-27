import '../../domain/entities/expense_category.dart';

/// Maps a `categories` row to the domain entity and back.
class CategoryModel extends ExpenseCategory {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.iconName,
    required super.colorValue,
    super.isDefault,
    super.sortOrder,
  });

  factory CategoryModel.fromMap(Map<String, Object?> map) => CategoryModel(
    id: map['id']! as String,
    name: map['name']! as String,
    iconName: map['icon_name']! as String,
    colorValue: (map['color_value']! as num).toInt(),
    isDefault: (map['is_default'] as num?)?.toInt() == 1,
    sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
  );

  factory CategoryModel.fromEntity(ExpenseCategory category) => CategoryModel(
    id: category.id,
    name: category.name,
    iconName: category.iconName,
    colorValue: category.colorValue,
    isDefault: category.isDefault,
    sortOrder: category.sortOrder,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'icon_name': iconName,
    'color_value': colorValue,
    'is_default': isDefault ? 1 : 0,
    'sort_order': sortOrder,
  };
}
