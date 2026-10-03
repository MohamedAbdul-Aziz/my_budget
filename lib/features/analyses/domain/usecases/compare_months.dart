import 'dart:math' as math;

import '../../../../core/error/api_result.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../expenses/domain/usecases/get_month_overview.dart';
import '../entities/month_comparison.dart';

/// Sets one month's spending against another's, category by category.
/// Income is left out, as everywhere on the analyses page.
class CompareMonths {
  const CompareMonths(this._repository);

  final ExpenseRepository _repository;

  Future<ApiResult<MonthComparison>> call(Month first, Month second) async {
    final firstResult = await _repository.getTransactionsForMonth(first);
    if (firstResult case ResultFailure(:final failure)) {
      return ResultFailure(failure);
    }
    final secondResult = await _repository.getTransactionsForMonth(second);
    if (secondResult case ResultFailure(:final failure)) {
      return ResultFailure(failure);
    }

    final (firstTotal, firstBreakdown) = GetMonthOverview.breakdownOf(
      firstResult.dataOrNull!,
    );
    final (secondTotal, secondBreakdown) = GetMonthOverview.breakdownOf(
      secondResult.dataOrNull!,
    );

    final categories = <String, ExpenseCategory>{};
    final firstById = <String, double>{};
    final secondById = <String, double>{};
    for (final item in firstBreakdown) {
      categories[item.category.id] = item.category;
      firstById[item.category.id] = item.total;
    }
    for (final item in secondBreakdown) {
      categories.putIfAbsent(item.category.id, () => item.category);
      secondById[item.category.id] = item.total;
    }

    final rows =
        [
          for (final MapEntry(key: id, value: category) in categories.entries)
            ComparisonRow(
              category: category,
              first: firstById[id] ?? 0,
              second: secondById[id] ?? 0,
            ),
        ]..sort(
          (a, b) => math
              .max(b.first, b.second)
              .compareTo(math.max(a.first, a.second)),
        );

    return Success(
      MonthComparison(
        first: first,
        second: second,
        firstTotal: firstTotal,
        secondTotal: secondTotal,
        rows: rows,
      ),
    );
  }
}
