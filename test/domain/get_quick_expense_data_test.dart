import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/expenses/domain/entities/category_usage.dart';
import 'package:my_budget/features/quick_expense/domain/usecases/get_quick_expense_data.dart';

ExpenseCategory _category(String id, String name, {int sortOrder = 0}) =>
    ExpenseCategory(
      id: id,
      name: name,
      iconName: 'category',
      colorValue: 0xFF546E7A,
      isDefault: true,
      sortOrder: sortOrder,
    );

final _food = _category('cat_food', 'Food');
final _transport = _category('cat_transport', 'Transportation', sortOrder: 1);
final _bills = _category('cat_bills', 'Bills', sortOrder: 2);
final _shopping = _category('cat_shopping', 'Shopping', sortOrder: 3);
final _work = _category('cat_work', 'Work', sortOrder: 4);
final _other = _category(ExpenseCategory.fallbackId, 'Other', sortOrder: 5);

final _all = [_food, _transport, _bills, _shopping, _work, _other];

void main() {
  group('shortcut ranking', () {
    test('falls back to the first few plus Other before any history', () {
      final ranked = GetQuickExpenseData.rank(_all, const []);

      expect(ranked, [_food, _transport, _bills, _other]);
    });

    test('puts the most used categories first', () {
      final ranked = GetQuickExpenseData.rank(_all, const [
        CategoryUsage(categoryId: 'cat_work', count: 12),
        CategoryUsage(categoryId: 'cat_bills', count: 7),
      ]);

      expect(ranked.take(2), [_work, _bills]);
    });

    test('pads with unused categories to fill the widget', () {
      final ranked = GetQuickExpenseData.rank(_all, const [
        CategoryUsage(categoryId: 'cat_work', count: 3),
      ]);

      expect(ranked, hasLength(GetQuickExpenseData.shortcutCount));
      expect(ranked.first, _work);
      expect(ranked.toSet(), hasLength(GetQuickExpenseData.shortcutCount));
    });

    test('never shows more shortcuts than the widget has room for', () {
      final ranked = GetQuickExpenseData.rank(_all, const [
        CategoryUsage(categoryId: 'cat_work', count: 5),
        CategoryUsage(categoryId: 'cat_food', count: 4),
        CategoryUsage(categoryId: 'cat_bills', count: 3),
        CategoryUsage(categoryId: 'cat_shopping', count: 2),
        CategoryUsage(categoryId: 'cat_transport', count: 1),
      ]);

      expect(ranked, [_work, _food, _bills, _shopping]);
    });

    test('ignores usage for a category that has since been deleted', () {
      final ranked = GetQuickExpenseData.rank(_all, const [
        CategoryUsage(categoryId: 'cat_deleted', count: 99),
        CategoryUsage(categoryId: 'cat_bills', count: 2),
      ]);

      expect(ranked.first, _bills);
      expect(ranked, hasLength(GetQuickExpenseData.shortcutCount));
    });

    test('copes with no categories at all', () {
      expect(GetQuickExpenseData.rank(const [], const []), isEmpty);
    });
  });
}
