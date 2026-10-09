import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/category_name.dart';
import '../entities/expense_category.dart';
import '../entities/transaction_type.dart';
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
    TransactionType type = TransactionType.expense,
  }) async {
    final trimmed = name.trim();
    final failure = validateName(trimmed);
    if (failure != null) return ResultFailure(failure);

    final taken = await nameTakenIn(_repository, trimmed, type);
    if (taken != null) return ResultFailure(taken);

    return _repository.createCategory(
      name: trimmed,
      iconName: iconName,
      colorValue: colorValue,
      type: type,
    );
  }

  /// A failure when another category of [type] already has [name], or when
  /// the categories cannot be read to tell; null when the name is free.
  static Future<Failure?> nameTakenIn(
    CategoryRepository repository,
    String name,
    TransactionType type, {
    String? exceptId,
  }) async {
    final existing = await repository.getCategories();
    return switch (existing) {
      ResultFailure(:final failure) => failure,
      Success(:final data)
          when CategoryName.isTaken(name, type, data, exceptId: exceptId) =>
        const ValidationFailure(FailureCode.categoryNameTaken),
      Success() => null,
    };
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
