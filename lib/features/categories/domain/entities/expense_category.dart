import 'package:equatable/equatable.dart';

/// A spending category. Pure Dart — the icon is stored as a stable key that the
/// presentation layer resolves to a `const IconData`, and the color as an ARGB
/// int, so nothing here depends on Flutter.
class ExpenseCategory extends Equatable {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    this.isDefault = false,
    this.sortOrder = 0,
  });

  /// The category every expense falls back to when its own is deleted.
  /// It always exists and can never be removed.
  static const String fallbackId = 'cat_other';

  final String id;
  final String name;
  final String iconName;
  final int colorValue;

  /// Seeded on first launch rather than created by the user.
  final bool isDefault;
  final int sortOrder;

  /// Every category except the fallback can be deleted, defaults included.
  bool get isDeletable => id != fallbackId;

  ExpenseCategory copyWith({
    String? name,
    String? iconName,
    int? colorValue,
    int? sortOrder,
    bool? isDefault,
  }) => ExpenseCategory(
    id: id,
    name: name ?? this.name,
    iconName: iconName ?? this.iconName,
    colorValue: colorValue ?? this.colorValue,
    isDefault: isDefault ?? this.isDefault,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    iconName,
    colorValue,
    isDefault,
    sortOrder,
  ];
}
