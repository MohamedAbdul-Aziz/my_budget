import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../domain/usecases/get_budget_status.dart';
import '../../domain/usecases/set_category_budget.dart';
import '../../domain/usecases/set_monthly_budget.dart';
import 'budget_state.dart';

/// The budgets of whichever month the home screen has selected, and the
/// edits made to them. Shared by the home screen card and the budgets page.
class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit({
    required GetBudgetStatus getBudgetStatus,
    required SetMonthlyBudget setMonthlyBudget,
    required SetCategoryBudget setCategoryBudget,
  }) : _getBudgetStatus = getBudgetStatus,
       _setMonthlyBudget = setMonthlyBudget,
       _setCategoryBudget = setCategoryBudget,
       super(const BudgetLoading());

  final GetBudgetStatus _getBudgetStatus;
  final SetMonthlyBudget _setMonthlyBudget;
  final SetCategoryBudget _setCategoryBudget;

  Month _month = Month.current();

  /// Counts reads, so that of two overlapping ones only the newer is shown.
  int _reads = 0;

  /// Reloads without a spinner once something is showing, so switching
  /// months or adding an expense does not flash the card.
  Future<void> load(Month month) {
    _month = month;
    return _fetch();
  }

  /// Reads the same month again, after something changed underneath it.
  Future<void> refresh() => _fetch();

  /// Each edit returns why it was refused, or null once it is saved, so the
  /// dialog asking for it can stay open and say what to fix.
  Future<FailureCode?> setMonthlyLimit(String amountText) =>
      _save(amountText, _setMonthlyBudget.call);

  Future<FailureCode?> removeMonthlyLimit() => _apply(_setMonthlyBudget(null));

  Future<FailureCode?> setCategoryLimit(String categoryId, String amountText) =>
      _save(amountText, (limit) => _setCategoryBudget(categoryId, limit));

  Future<FailureCode?> removeCategoryLimit(String categoryId) =>
      _apply(_setCategoryBudget(categoryId, null));

  Future<FailureCode?> _save(
    String amountText,
    Future<ApiResult<void>> Function(double limit) save,
  ) async {
    final limit = AmountInput.parse(amountText);
    if (limit == null) return FailureCode.amountInvalid;
    return _apply(save(limit));
  }

  Future<FailureCode?> _apply(Future<ApiResult<void>> saving) async {
    final failure = (await saving).failureOrNull;
    if (failure != null) return failure.code;
    await _fetch();
    return null;
  }

  Future<void> _fetch() async {
    final read = ++_reads;
    final result = await _getBudgetStatus(_month);
    if (isClosed || read != _reads) return;
    switch (result) {
      case Success(:final data):
        emit(BudgetReady(data));
      case ResultFailure(:final failure):
        emit(BudgetLoadFailure(failure.code));
    }
  }
}
