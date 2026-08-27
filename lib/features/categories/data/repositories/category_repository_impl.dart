import 'dart:math';

import '../../../../core/error/api_result.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._localDataSource);

  final CategoryLocalDataSource _localDataSource;
  final Random _random = Random();

  @override
  Future<ApiResult<List<ExpenseCategory>>> getCategories() =>
      ApiResult.guard(() async => await _localDataSource.getCategories());

  @override
  Future<ApiResult<ExpenseCategory>> createCategory({
    required String name,
    required String iconName,
    required int colorValue,
  }) => ApiResult.guard(() async {
    final existing = await _localDataSource.getCategories();
    final model = CategoryModel(
      id: _newId(),
      name: name,
      iconName: iconName,
      colorValue: colorValue,
      // New categories sort after everything already there.
      sortOrder: existing.isEmpty
          ? 0
          : existing.map((c) => c.sortOrder).reduce(max) + 1,
    );
    return await _localDataSource.insertCategory(model);
  });

  @override
  Future<ApiResult<ExpenseCategory>> updateCategory(ExpenseCategory category) =>
      ApiResult.guard(
        () async => await _localDataSource.updateCategory(
          CategoryModel.fromEntity(category),
        ),
      );

  @override
  Future<ApiResult<int>> deleteCategory(String categoryId) =>
      ApiResult.guard(() async => await _localDataSource.deleteCategory(categoryId));

  String _newId() =>
      'cat_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(0xFFFF)}';
}
