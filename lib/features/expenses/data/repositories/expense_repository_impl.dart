import 'dart:math';

import '../../../../core/error/api_result.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/month.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._localDataSource);

  final ExpenseLocalDataSource _localDataSource;
  final Random _random = Random();

  @override
  Future<ApiResult<List<Expense>>> getExpensesForMonth(Month month) =>
      ApiResult.guard(() async => await _localDataSource.getExpensesForMonth(month));

  @override
  Future<ApiResult<List<MonthlySummary>>> getMonthlySummaries() =>
      ApiResult.guard(() async => await _localDataSource.getMonthlySummaries());

  @override
  Future<ApiResult<Expense>> addExpense({
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) => ApiResult.guard(() async {
    final id = _newId();
    await _localDataSource.insertExpense(
      ExpenseModel.toRow(
        id: id,
        amount: amount,
        categoryId: categoryId,
        date: date,
        createdAt: DateTime.now(),
        description: description,
      ),
    );
    // Read back so the caller gets the expense with its category attached.
    return await _localDataSource.getExpenseById(id);
  });

  @override
  Future<ApiResult<Expense>> updateExpense({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) => ApiResult.guard(() async {
    final existing = await _localDataSource.getExpenseById(id);
    await _localDataSource.updateExpense(
      id,
      ExpenseModel.toRow(
        id: id,
        amount: amount,
        categoryId: categoryId,
        date: date,
        createdAt: existing.createdAt,
        description: description,
      ),
    );
    return await _localDataSource.getExpenseById(id);
  });

  @override
  Future<ApiResult<void>> deleteExpense(String id) =>
      ApiResult.guard(() async => await _localDataSource.deleteExpense(id));

  String _newId() =>
      'exp_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(0xFFFF)}';
}
