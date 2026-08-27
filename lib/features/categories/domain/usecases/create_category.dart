import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense_category.dart';
import '../repositories/category_repository.dart';

class CreateCategory {
  /// Also enforced by the name field's input limit.
  static const int maxNameLength = 30;

  const CreateCategory(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<ExpenseCategory>> call({
    required String name,
    required String iconName,
    required int colorValue,
  }) async {
    final trimmed = name.trim();
    final failure = validateName(trimmed);
    if (failure != null) return ResultFailure(failure);

    return _repository.createCategory(
      name: trimmed,
      iconName: iconName,
      colorValue: colorValue,
    );
  }

  static Failure? validateName(String name) {
    if (name.trim().isEmpty) {
      return const ValidationFailure(FailureCode.categoryNameRequired);
    }
    if (name.trim().length > maxNameLength) {
      return const ValidationFailure(FailureCode.categoryNameTooLong);
    }
    return null;
  }
}
