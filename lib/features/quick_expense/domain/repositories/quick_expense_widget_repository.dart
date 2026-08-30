import '../../../../core/error/api_result.dart';
import '../entities/quick_add_request.dart';
import '../entities/quick_expense_snapshot.dart';

abstract interface class QuickExpenseWidgetRepository {
  /// Hands the widget a new snapshot and asks Android to redraw it.
  Future<ApiResult<void>> publish(QuickExpenseSnapshot snapshot);

  /// The request the app was cold-started with, or null for a normal launch.
  /// Consuming it clears it, so a later resume does not reopen the sheet.
  Future<QuickAddRequest?> consumeLaunchRequest();

  /// Taps that arrive while the app is already running.
  Stream<QuickAddRequest> get requests;
}
