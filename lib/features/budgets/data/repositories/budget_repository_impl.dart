import '../../../../core/error/api_result.dart';
import '../../domain/entities/budget_limits.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_data_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl(this._localDataSource);

  final BudgetLocalDataSource _localDataSource;

  @override
  Future<ApiResult<BudgetLimits>> getLimits() =>
      ApiResult.guard(_localDataSource.readLimits);

  @override
  Future<ApiResult<void>> saveMonthlyLimit(double? limit) =>
      ApiResult.guard(() => _localDataSource.writeMonthly(limit));

  @override
  Future<ApiResult<void>> saveCategoryLimit(String categoryId, double? limit) =>
      ApiResult.guard(() => _localDataSource.writeCategory(categoryId, limit));
}
