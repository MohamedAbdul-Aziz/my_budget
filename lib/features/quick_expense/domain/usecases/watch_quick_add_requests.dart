import '../entities/quick_add_request.dart';
import '../repositories/quick_expense_widget_repository.dart';

/// Widget taps that arrive while the app is already open.
class WatchQuickAddRequests {
  const WatchQuickAddRequests(this._repository);

  final QuickExpenseWidgetRepository _repository;

  Stream<QuickAddRequest> call() => _repository.requests;
}
