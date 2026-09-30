import '../../../../core/error/api_result.dart';
import '../entities/expense.dart';
import '../entities/transaction_search.dart';
import '../repositories/expense_repository.dart';

/// Finds transactions in every month, newest first. An empty search finds
/// nothing rather than everything: the home screen already lists the month.
class SearchTransactions {
  const SearchTransactions(this._repository);

  /// Enough for any real search; a broader one should be narrowed down.
  static const int maxResults = 200;

  final ExpenseRepository _repository;

  Future<ApiResult<List<Expense>>> call(TransactionSearch search) async {
    if (search.isEmpty) return const Success([]);
    return _repository.searchTransactions(
      search.copyWith(text: search.text.trim()),
      limit: maxResults,
    );
  }
}
