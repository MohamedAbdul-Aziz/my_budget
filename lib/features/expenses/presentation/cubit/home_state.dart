import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/month.dart';
import '../../domain/entities/month_overview.dart';
import '../../domain/entities/monthly_summary.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoadFailure extends HomeState {
  const HomeLoadFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class HomeReady extends HomeState {
  const HomeReady({
    required this.overview,
    required this.months,
    this.canUndoDelete = false,
    this.notice,
  });

  /// The selected month plus its expenses, total and category breakdown.
  final MonthOverview overview;

  /// Every month that has spending, newest first.
  final List<MonthlySummary> months;

  /// True while a just-deleted expense can still be restored.
  final bool canUndoDelete;

  /// Set for one emission after a delete or an error.
  final UiNotice? notice;

  Month get month => overview.month;

  HomeReady copyWith({
    MonthOverview? overview,
    List<MonthlySummary>? months,
    bool? canUndoDelete,
    UiNotice? notice,
  }) => HomeReady(
    overview: overview ?? this.overview,
    months: months ?? this.months,
    canUndoDelete: canUndoDelete ?? this.canUndoDelete,
    notice: notice,
  );

  @override
  List<Object?> get props => [overview, months, canUndoDelete, notice];
}
