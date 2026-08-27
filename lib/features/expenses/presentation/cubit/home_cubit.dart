import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/month.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_month_overview.dart';
import '../../domain/usecases/get_monthly_summaries.dart';
import 'home_state.dart';

/// Drives the home screen: the selected month, its expenses and totals, and
/// the list of months the user can switch to.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetMonthOverview getMonthOverview,
    required GetMonthlySummaries getMonthlySummaries,
    required DeleteExpense deleteExpense,
    required AddExpense addExpense,
  }) : _getMonthOverview = getMonthOverview,
       _getMonthlySummaries = getMonthlySummaries,
       _deleteExpense = deleteExpense,
       _addExpense = addExpense,
       super(const HomeLoading());

  final GetMonthOverview _getMonthOverview;
  final GetMonthlySummaries _getMonthlySummaries;
  final DeleteExpense _deleteExpense;
  final AddExpense _addExpense;

  Month _month = Month.current();

  /// Kept only until the undo snackbar disappears.
  Expense? _lastDeleted;

  Month get selectedMonth => _month;

  /// First load — shows the spinner. Later calls should use [refresh].
  Future<void> load() async {
    emit(const HomeLoading());
    await _fetch();
  }

  Future<void> selectMonth(Month month) async {
    if (month == _month) return;
    _month = month;
    _lastDeleted = null;
    await _fetch();
  }

  /// Silent reload used after returning from the add/edit screen.
  Future<void> refresh() => _fetch();

  Future<void> remove(Expense expense) async {
    final result = await _deleteExpense(expense.id);
    switch (result) {
      case Success():
        _lastDeleted = expense;
        await _fetch(notice: UiNotice(NoticeCode.expenseDeleted));
      case ResultFailure(:final failure):
        _emitNotice(UiNotice.from(failure));
    }
  }

  /// Re-adds the last deleted expense. It comes back with a new id, which is
  /// invisible to the user.
  Future<void> undoDelete() async {
    final expense = _lastDeleted;
    if (expense == null) return;
    _lastDeleted = null;

    final result = await _addExpense(
      amount: expense.amount,
      categoryId: expense.category.id,
      date: expense.date,
      description: expense.description,
    );
    switch (result) {
      case Success():
        await _fetch(notice: UiNotice(NoticeCode.expenseRestored));
      case ResultFailure(:final failure):
        _emitNotice(UiNotice.from(failure));
    }
  }

  Future<void> _fetch({UiNotice? notice}) async {
    final overviewResult = await _getMonthOverview(_month);
    if (overviewResult case ResultFailure(:final failure)) {
      emit(HomeLoadFailure(failure));
      return;
    }

    final summariesResult = await _getMonthlySummaries();
    emit(
      HomeReady(
        overview: (overviewResult as Success).data,
        // A failed summary read only costs the month switcher its list.
        months: summariesResult.dataOrNull ?? const [],
        canUndoDelete: _lastDeleted != null,
        notice: notice,
      ),
    );
  }

  void _emitNotice(UiNotice notice) {
    final current = state;
    if (current is HomeReady) emit(current.copyWith(notice: notice));
  }
}
