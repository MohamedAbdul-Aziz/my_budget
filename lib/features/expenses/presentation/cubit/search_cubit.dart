import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../domain/entities/transaction_search.dart';
import '../../domain/usecases/search_transactions.dart';
import 'search_state.dart';

/// One search screen: the text typed so far, the filters, and what they find.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchTransactions searchTransactions})
    : _searchTransactions = searchTransactions,
      super(const SearchIdle(TransactionSearch()));

  /// Typing waits this long for a pause before searching, so every keystroke
  /// does not run a query.
  static const Duration typingPause = Duration(milliseconds: 300);

  final SearchTransactions _searchTransactions;

  /// The latest criteria, ahead of [state] while typing has not paused yet.
  TransactionSearch _search = const TransactionSearch();
  Timer? _typing;

  /// Counts searches, so that of two overlapping ones only the newer shows.
  int _runs = 0;

  void setText(String text) {
    _search = _search.copyWith(text: text);
    _typing?.cancel();
    _typing = Timer(typingPause, _run);
  }

  Future<void> setType(TransactionType? type) {
    _search = _search.copyWith(type: () => type);
    return _run();
  }

  Future<void> setCategories(Set<String> categoryIds) {
    _search = _search.copyWith(categoryIds: categoryIds);
    return _run();
  }

  Future<void> setDates(DateTime? from, DateTime? to) {
    _search = _search.copyWith(from: () => from, to: () => to);
    return _run();
  }

  Future<void> clearFilters() {
    _search = _search.withoutFilters();
    return _run();
  }

  /// Runs the same search again, after one of its results was edited.
  Future<void> refresh() => _run();

  Future<void> _run() async {
    _typing?.cancel();
    final search = _search;
    final run = ++_runs;
    if (search.isEmpty) {
      emit(SearchIdle(search));
      return;
    }

    emit(
      SearchLoading(
        search,
        previous: switch (state) {
          SearchResults(:final results) => results,
          SearchLoading(:final previous) => previous,
          _ => const [],
        },
      ),
    );
    final result = await _searchTransactions(search);
    if (run != _runs || isClosed) return;
    emit(switch (result) {
      Success(:final data) => SearchResults(search, data),
      ResultFailure(:final failure) => SearchFailure(search, failure.code),
    });
  }

  @override
  Future<void> close() {
    _typing?.cancel();
    return super.close();
  }
}
