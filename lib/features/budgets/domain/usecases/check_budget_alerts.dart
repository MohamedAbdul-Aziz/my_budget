import '../../../../core/error/api_result.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../entities/budget_alert.dart';
import '../entities/budget_line.dart';
import '../entities/budget_status.dart';
import 'get_budget_status.dart';

/// Which budgets a just-saved expense pushed past 80% or 100% of their limit.
class CheckBudgetAlerts {
  const CheckBudgetAlerts(this._getBudgetStatus);

  final GetBudgetStatus _getBudgetStatus;

  /// Call once [saved] is stored. [replaced] is the expense as it was before
  /// an edit, and null for a new one.
  Future<ApiResult<List<BudgetAlert>>> call({
    required Expense saved,
    Expense? replaced,
  }) async {
    final result = await _getBudgetStatus(saved.month);
    return result.map(
      (after) => crossed(after, saved: saved, replaced: replaced),
    );
  }

  /// Compares [after] with the month as it stood before the save, which is
  /// [after] minus what the save changed. The monthly budget comes first,
  /// then categories in the user's order.
  ///
  /// Only the highest threshold crossed is reported for each budget, and each
  /// is reported once: an expense that leaves a budget between 80% and 100%
  /// when it already was says nothing new.
  static List<BudgetAlert> crossed(
    BudgetStatus after, {
    required Expense saved,
    Expense? replaced,
  }) {
    // An edit that moved the expense here from another month only added to
    // this one; its old month can only have gone down.
    final removed = replaced != null && replaced.month == saved.month
        ? replaced
        : null;

    final addedToTotal = saved.amount - (removed?.amount ?? 0);
    double addedTo(String categoryId) =>
        (saved.category.id == categoryId ? saved.amount : 0.0) -
        (removed != null && removed.category.id == categoryId
            ? removed.amount
            : 0.0);

    return [
      if (after.total case final total?)
        if (_crossed(total, addedToTotal) case final threshold?)
          BudgetAlert(threshold: threshold, line: total),
      for (final entry in after.categories)
        if (entry.line case final line?)
          if (_crossed(line, addedTo(entry.category.id)) case final threshold?)
            BudgetAlert(
              threshold: threshold,
              line: line,
              category: entry.category,
            ),
    ];
  }

  static BudgetThreshold? _crossed(BudgetLine after, double added) {
    if (added <= 0) return null;
    final before = after.spent - added;
    for (final threshold in BudgetThreshold.values.reversed) {
      if (after.reaches(threshold.share) &&
          !after.reaches(threshold.share, spent: before)) {
        return threshold;
      }
    }
    return null;
  }
}
