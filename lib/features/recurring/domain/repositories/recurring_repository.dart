import '../../../../core/error/api_result.dart';
import '../entities/recurrence_frequency.dart';
import '../entities/recurring_expense.dart';
import '../entities/recurring_mode.dart';
import '../entities/recurring_payment.dart';

abstract interface class RecurringRepository {
  Future<ApiResult<List<RecurringExpense>>> getRecurring();

  Future<ApiResult<RecurringExpense>> createRecurring({
    required String title,
    required double amount,
    required String categoryId,
    required RecurrenceFrequency frequency,
    required int dueDay,
    int? dueMonth,
    required RecurringMode mode,
    required DateTime startsOn,
  });

  Future<ApiResult<RecurringExpense>> updateRecurring(
    RecurringExpense recurring,
  );

  /// Stops the schedule. Transactions it already logged stay.
  Future<ApiResult<void>> deleteRecurring(String id);

  /// Logs the payment due on [due] as a transaction dated [paidAt] and
  /// settles every payment up to [due], in one step.
  ///
  /// Fails with `FailureCode.alreadyPaid` when [due] is already settled, so
  /// two callers racing for the same payment log it once.
  Future<ApiResult<RecurringPayment>> recordPayment(
    RecurringExpense recurring, {
    required DateTime due,
    required DateTime paidAt,
  });

  /// Deletes the transaction [payment] logged and makes its due date unpaid
  /// again.
  Future<ApiResult<void>> undoPayment(RecurringPayment payment);
}
