import '../../../../core/error/api_result.dart';
import '../../domain/entities/quick_expense_snapshot.dart';
import '../../domain/repositories/quick_expense_widget_repository.dart';
import '../datasources/quick_expense_widget_channel.dart';
import '../models/quick_expense_payload.dart';

class QuickExpenseWidgetRepositoryImpl implements QuickExpenseWidgetRepository {
  const QuickExpenseWidgetRepositoryImpl(this._channel);

  final QuickExpenseWidgetChannel _channel;

  @override
  Future<ApiResult<void>> publish(QuickExpenseSnapshot snapshot) =>
      ApiResult.guard(
        () async => _channel.publish(QuickExpensePayload.encode(snapshot)),
      );
}
