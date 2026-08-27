import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_category.dart';
import 'categories_state.dart';

/// Shared by the manage-categories screen and the category picker in the
/// expense form, so both always show the same list.
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required GetCategories getCategories,
    required CreateCategory createCategory,
    required UpdateCategory updateCategory,
    required DeleteCategory deleteCategory,
  }) : _getCategories = getCategories,
       _createCategory = createCategory,
       _updateCategory = updateCategory,
       _deleteCategory = deleteCategory,
       super(const CategoriesLoading());

  final GetCategories _getCategories;
  final CreateCategory _createCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;

  Future<void> load() async {
    final result = await _getCategories();
    switch (result) {
      case Success(:final data):
        emit(CategoriesReady(categories: data));
      case ResultFailure(:final failure):
        emit(CategoriesLoadFailure(failure));
    }
  }

  /// Returns the new category so a caller can select it straight away.
  Future<ExpenseCategory?> create({
    required String name,
    required String iconName,
    required int colorValue,
  }) async {
    final result = await _createCategory(
      name: name,
      iconName: iconName,
      colorValue: colorValue,
    );
    await _afterMutation(
      result,
      success: UiNotice(NoticeCode.categoryAdded, name: name),
    );
    return result.dataOrNull;
  }

  Future<void> edit(ExpenseCategory category) async {
    final result = await _updateCategory(category);
    await _afterMutation(result, success: UiNotice(NoticeCode.categoryUpdated));
  }

  Future<void> remove(ExpenseCategory category) async {
    final result = await _deleteCategory(category);
    // How many expenses were re-homed decides which sentence the UI shows.
    final moved = result.dataOrNull ?? 0;
    await _afterMutation(
      result,
      success: moved > 0
          ? UiNotice(
              NoticeCode.categoryDeletedWithMoves,
              name: category.name,
              count: moved,
            )
          : UiNotice(NoticeCode.categoryDeleted, name: category.name),
    );
  }

  /// Reloads the list, then attaches the outcome to the new state.
  Future<void> _afterMutation(
    ApiResult<Object?> result, {
    required UiNotice success,
  }) async {
    final failure = result.failureOrNull;
    if (failure == null) await load();

    final current = state;
    if (current is! CategoriesReady) return;
    emit(
      current.copyWith(
        notice: failure == null ? success : UiNotice.from(failure),
      ),
    );
  }
}
