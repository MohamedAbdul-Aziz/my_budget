import '../../../../core/error/api_result.dart';
import '../entities/expense_category.dart';

abstract interface class CategoryRepository {
  Future<ApiResult<List<ExpenseCategory>>> getCategories();

  Future<ApiResult<ExpenseCategory>> createCategory({
    required String name,
    required String iconName,
    required int colorValue,
  });

  Future<ApiResult<ExpenseCategory>> updateCategory(ExpenseCategory category);

  /// Deletes [categoryId] and moves any expense that used it to the
  /// non-deletable fallback category, so no spending is ever lost.
  Future<ApiResult<int>> deleteCategory(String categoryId);
}
