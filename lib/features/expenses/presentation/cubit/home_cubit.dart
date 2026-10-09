import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/month.dart';
import '../../domain/entities/period.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_monthly_summaries.dart';
import '../../domain/usecases/get_period_overview.dart';
import 'home_state.dart';

/// Drives the home screen: the selected period (a day, week, month or year),
/// its transactions and totals, and the list of months with spending.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetPeriodOverview getPeriodOverview,
    required GetMonthlySummaries getMonthlySummaries,
    required DeleteExpense deleteExpense,
    required AddExpense addExpense,
  }) : _getPeriodOverview = getPeriodOverview,
       _getMonthlySummaries = getMonthlySummaries,
       _deleteExpense = deleteExpense,
       _addExpense = addExpense,
       super(const HomeLoading());

  final GetPeriodOverview _getPeriodOverview;
  final GetMonthlySummaries _getMonthlySummaries;
  final DeleteExpense _deleteExpense;
  final AddExpense _addExpense;

  /// Opens on this month, around today.
  Period _period = Period(PeriodKind.month, DateTime.now());

  /// Kept only until the undo snackbar disappears.
  Expense? _lastDeleted;

  Period get period => _period;

  /// The month budgets and analyses follow: the one the picked day is in.
  Month get selectedMonth => _period.month;

  /// First load — shows the spinner. Later calls should use [refresh].
  Future<void> load() async {
    emit(const HomeLoading());
    await _fetch();
  }

  /// Shows [month] as a whole, around today when it is this month.
  Future<void> selectMonth(Month month) => _select(
    Period(
      PeriodKind.month,
      month == Month.current() ? DateTime.now() : month.start,
      firstWeekday: _period.firstWeekday,
    ),
  );

  /// The same day seen as a day, a week, a month or a year. [firstWeekday]
  /// is when the user's weeks start (`DateTime.monday` … `sunday`).
  Future<void> selectKind(PeriodKind kind, {int? firstWeekday}) => _select(
    Period(
      kind,
      _period.anchor,
      firstWeekday: firstWeekday ?? _period.firstWeekday,
    ),
  );

  /// The period [by] steps earlier or later. Never past the period holding
  /// today: there is nothing to see in the future.
  Future<void> shift(int by, {DateTime? now}) async {
    if (by > 0 && !_period.endsBefore(now ?? DateTime.now())) return;
    await _select(_period.shift(by));
  }

  /// The period of the same kind holding [day] (today at the latest).
  Future<void> selectDay(DateTime day, {DateTime? now}) {
    final today = now ?? DateTime.now();
    return _select(_period.at(day.isAfter(today) ? today : day));
  }

  Future<void> _select(Period period) async {
    if (period == _period) return;
    _period = period;
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
        await _fetch(
          notice: UiNotice(
            expense.isIncome
                ? NoticeCode.incomeDeleted
                : NoticeCode.expenseDeleted,
          ),
        );
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
        await _fetch(
          notice: UiNotice(
            expense.isIncome
                ? NoticeCode.incomeRestored
                : NoticeCode.expenseRestored,
          ),
        );
      case ResultFailure(:final failure):
        _emitNotice(UiNotice.from(failure));
    }
  }

  Future<void> _fetch({UiNotice? notice}) async {
    final overviewResult = await _getPeriodOverview(_period);
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
