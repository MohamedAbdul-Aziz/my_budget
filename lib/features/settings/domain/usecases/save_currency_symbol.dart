import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class SaveCurrencySymbol {
  static const int maxSymbolLength = 4;

  const SaveCurrencySymbol(this._repository);

  final SettingsRepository _repository;

  Future<ApiResult<AppSettings>> call(String symbol) {
    final trimmed = symbol.trim();
    if (trimmed.isEmpty || trimmed.length > maxSymbolLength) {
      return Future.value(
        const ResultFailure(ValidationFailure(FailureCode.currencySymbolInvalid)),
      );
    }
    return _repository.saveCurrencySymbol(trimmed);
  }
}
