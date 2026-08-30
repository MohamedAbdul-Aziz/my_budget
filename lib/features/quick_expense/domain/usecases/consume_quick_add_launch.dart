import '../entities/quick_add_request.dart';
import '../repositories/quick_expense_widget_repository.dart';

/// The widget tap that cold-started the app, if that is how it was opened.
class ConsumeQuickAddLaunch {
  const ConsumeQuickAddLaunch(this._repository);

  final QuickExpenseWidgetRepository _repository;

  Future<QuickAddRequest?> call() => _repository.consumeLaunchRequest();
}
