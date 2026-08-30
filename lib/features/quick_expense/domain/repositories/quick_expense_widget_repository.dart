import '../../../../core/error/api_result.dart';
import '../entities/quick_expense_snapshot.dart';

abstract interface class QuickExpenseWidgetRepository {
  /// Hands the widget a new snapshot and asks Android to redraw it.
  ///
  /// Taps travel the other way without touching Dart state: Android opens the
  /// quick-add activity directly, carrying the category on its initial route.
  Future<ApiResult<void>> publish(QuickExpenseSnapshot snapshot);
}
