import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense_category.dart';
import '../repositories/category_repository.dart';

/// Removes a category. Expenses that used it are moved to the fallback
/// category rather than deleted; the result is how many were moved.
class DeleteCategory {
  const DeleteCategory(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<int>> call(ExpenseCategory category) async {
    if (!category.isDeletable) {
      return const ResultFailure(
        ValidationFailure(FailureCode.categoryProtected),
      );
    }
    return _repository.deleteCategory(category.id);
  }
}
