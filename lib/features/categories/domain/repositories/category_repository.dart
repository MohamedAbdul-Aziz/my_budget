import '../../../../core/error/api_result.dart';
import '../entities/expense_category.dart';
import '../entities/transaction_type.dart';

abstract interface class CategoryRepository {
  Future<ApiResult<List<ExpenseCategory>>> getCategories();

  Future<ApiResult<ExpenseCategory>> createCategory({
    required String name,
    required String iconName,
    required int colorValue,
    required TransactionType type,
  });

  Future<ApiResult<ExpenseCategory>> updateCategory(ExpenseCategory category);

  /// Deletes [categoryId] and moves any transaction that used it to the
  /// non-deletable fallback category of the same type, so nothing recorded
  /// is ever lost.
  Future<ApiResult<int>> deleteCategory(String categoryId);
}
