import '../../../../core/error/api_result.dart';
import '../entities/quick_expense_snapshot.dart';
import '../repositories/quick_expense_widget_repository.dart';

class PublishQuickExpenseWidget {
  const PublishQuickExpenseWidget(this._repository);

  final QuickExpenseWidgetRepository _repository;

  Future<ApiResult<void>> call(QuickExpenseSnapshot snapshot) =>
      _repository.publish(snapshot);
}
