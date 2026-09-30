import 'dart:math';

import '../../../../core/error/api_result.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../domain/entities/recurrence_frequency.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/entities/recurring_mode.dart';
import '../../domain/entities/recurring_payment.dart';
import '../../domain/repositories/recurring_repository.dart';
import '../datasources/recurring_local_data_source.dart';
import '../models/recurring_expense_model.dart';

class RecurringRepositoryImpl implements RecurringRepository {
  RecurringRepositoryImpl(this._localDataSource);

  final RecurringLocalDataSource _localDataSource;
  final Random _random = Random();

  @override
  Future<ApiResult<List<RecurringExpense>>> getRecurring() =>
      ApiResult.guard(() async => await _localDataSource.getRecurring());

  @override
  Future<ApiResult<RecurringExpense>> createRecurring({
    required String title,
    required double amount,
    required String categoryId,
    required RecurrenceFrequency frequency,
    required int dueDay,
    int? dueMonth,
    required RecurringMode mode,
    required DateTime startsOn,
  }) => ApiResult.guard(() async {
    final id = _newId();
    await _localDataSource.insertRecurring({
      'id': id,
      'title': title,
      'amount': amount,
      'category_id': categoryId,
      'frequency': frequency.storageKey,
      'due_day': dueDay,
      'due_month': dueMonth,
      'mode': mode.storageKey,
      'starts_on': RecurringExpenseModel.dayKey(startsOn),
      'paid_through': null,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
    // Read back so the caller gets it with its category attached.
    return await _localDataSource.getRecurringById(id);
  });

  @override
  Future<ApiResult<RecurringExpense>> updateRecurring(
    RecurringExpense recurring,
  ) => ApiResult.guard(() async {
    await _localDataSource.updateRecurring(
      recurring.id,
      RecurringExpenseModel.toRow(recurring),
    );
    return await _localDataSource.getRecurringById(recurring.id);
  });

  @override
  Future<ApiResult<void>> deleteRecurring(String id) =>
      ApiResult.guard(() => _localDataSource.deleteRecurring(id));

  @override
  Future<ApiResult<RecurringPayment>> recordPayment(
    RecurringExpense recurring, {
    required DateTime due,
    required DateTime paidAt,
  }) => ApiResult.guard(() async {
    final expenseId = RecurringExpenseModel.expenseIdFor(recurring.id, due);
    final previous = await _localDataSource.recordPayment(
      recurringId: recurring.id,
      due: due,
      expenseRow: ExpenseModel.toRow(
        id: expenseId,
        amount: recurring.amount,
        categoryId: recurring.category.id,
        date: paidAt,
        createdAt: DateTime.now(),
        description: recurring.title,
      ),
    );
    return RecurringPayment(
      recurringId: recurring.id,
      expenseId: expenseId,
      due: RecurringExpense.dayOf(due),
      previousPaidThrough: previous,
    );
  });

  @override
  Future<ApiResult<void>> undoPayment(RecurringPayment payment) =>
      ApiResult.guard(() => _localDataSource.undoPayment(payment));

  String _newId() =>
      'rec_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(0xFFFF)}';
}
