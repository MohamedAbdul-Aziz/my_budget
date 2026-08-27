import '../../../core/l10n/app_strings.dart';
import '../domain/entities/expense_category.dart';

/// Seeded categories are stored under fixed ids with English names, so their
/// display name is translated. Categories the user created keep their own
/// name exactly as typed.
String categoryLabel(AppStrings strings, ExpenseCategory category) =>
    category.isDefault
    ? strings.defaultCategoryName(category.id) ?? category.name
    : category.name;
