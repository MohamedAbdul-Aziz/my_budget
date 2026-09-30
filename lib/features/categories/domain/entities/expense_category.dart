import 'package:equatable/equatable.dart';

import 'transaction_type.dart';

/// A spending or income category. Pure Dart — the icon is stored as a stable
/// key that the presentation layer resolves to a `const IconData`, and the
/// color as an ARGB int, so nothing here depends on Flutter.
class ExpenseCategory extends Equatable {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    this.type = TransactionType.expense,
    this.isDefault = false,
    this.sortOrder = 0,
  });

  /// The category every expense falls back to when its own is deleted.
  /// It always exists and can never be removed.
  static const String fallbackId = 'cat_other';

  /// The same, for income.
  static const String incomeFallbackId = 'cat_income_other';

  static String fallbackIdFor(TransactionType type) => switch (type) {
    TransactionType.expense => fallbackId,
    TransactionType.income => incomeFallbackId,
  };

  final String id;
  final String name;
  final String iconName;
  final int colorValue;

  /// Fixed when the category is created: changing it would silently turn
  /// every transaction in it from spending into income or back.
  final TransactionType type;

  /// Seeded on first launch rather than created by the user.
  final bool isDefault;
  final int sortOrder;

  bool get isIncome => type == TransactionType.income;

  /// Every category except the two fallbacks can be deleted, defaults
  /// included.
  bool get isDeletable => id != fallbackId && id != incomeFallbackId;

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
    type: type,
    isDefault: isDefault ?? this.isDefault,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    iconName,
    colorValue,
    type,
    isDefault,
    sortOrder,
  ];
}
