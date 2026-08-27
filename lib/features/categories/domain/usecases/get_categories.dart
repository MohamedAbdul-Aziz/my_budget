import '../../../../core/error/api_result.dart';
import '../entities/expense_category.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<List<ExpenseCategory>>> call() => _repository.getCategories();
}
