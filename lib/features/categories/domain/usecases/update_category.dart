import '../../../../core/error/api_result.dart';
import '../entities/expense_category.dart';
import '../repositories/category_repository.dart';
import 'create_category.dart';

class UpdateCategory {
  const UpdateCategory(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<ExpenseCategory>> call(ExpenseCategory category) async {
    final failure = CreateCategory.validateName(category.name);
    if (failure != null) return ResultFailure(failure);

    return _repository.updateCategory(
      category.copyWith(name: category.name.trim()),
    );
  }
}
