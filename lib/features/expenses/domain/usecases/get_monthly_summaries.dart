import '../../../../core/error/api_result.dart';
import '../entities/monthly_summary.dart';
import '../repositories/expense_repository.dart';

/// Every month that has spending, newest first — powers the month switcher.
class GetMonthlySummaries {
  const GetMonthlySummaries(this._repository);

  final ExpenseRepository _repository;

  Future<ApiResult<List<MonthlySummary>>> call() =>
      _repository.getMonthlySummaries();
}
