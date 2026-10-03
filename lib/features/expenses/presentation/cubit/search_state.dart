import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/transaction_search.dart';

/// Every state carries the search it is about, so the filters on screen always
/// show what the results are for.
sealed class SearchState extends Equatable {
  const SearchState(this.search);

  final TransactionSearch search;

  @override
  List<Object?> get props => [search];
}

/// Nothing asked for yet.
final class SearchIdle extends SearchState {
  const SearchIdle(super.search);
}

final class SearchLoading extends SearchState {
  const SearchLoading(super.search, {this.previous = const []});

  /// The last results, kept on screen until the new ones arrive.
  final List<Expense> previous;

  @override
  List<Object?> get props => [search, previous];
}

final class SearchResults extends SearchState {
  const SearchResults(super.search, this.results);

  final List<Expense> results;

  @override
  List<Object?> get props => [search, results];
}

final class SearchFailure extends SearchState {
  const SearchFailure(super.search, this.error);

  final FailureCode error;

  @override
  List<Object?> get props => [search, error];
}
