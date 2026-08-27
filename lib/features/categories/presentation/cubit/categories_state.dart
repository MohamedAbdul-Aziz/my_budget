import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/expense_category.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

final class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

final class CategoriesLoadFailure extends CategoriesState {
  const CategoriesLoadFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class CategoriesReady extends CategoriesState {
  const CategoriesReady({required this.categories, this.notice});

  final List<ExpenseCategory> categories;

  /// Set for one emission after a create/edit/delete.
  final UiNotice? notice;

  CategoriesReady copyWith({
    List<ExpenseCategory>? categories,
    UiNotice? notice,
  }) => CategoriesReady(
    categories: categories ?? this.categories,
    notice: notice,
  );

  @override
  List<Object?> get props => [categories, notice];
}
