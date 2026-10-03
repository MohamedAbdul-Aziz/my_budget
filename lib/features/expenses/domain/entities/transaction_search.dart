import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/transaction_type.dart';

/// What to look for across every month: text in the note or an amount, and
/// optional filters. All of them must match.
class TransactionSearch extends Equatable {
  const TransactionSearch({
    this.text = '',
    this.type,
    this.categoryIds = const {},
    this.from,
    this.to,
  });

  /// Matched against the note, ignoring case, or against the amount when it
  /// reads as one.
  final String text;

  /// Null for both spending and income.
  final TransactionType? type;

  /// Empty for any category.
  final Set<String> categoryIds;

  /// Calendar days, both included; the time of day is ignored.
  final DateTime? from;
  final DateTime? to;

  /// Nothing asked for yet, so there is nothing to look up.
  bool get isEmpty =>
      text.trim().isEmpty &&
      type == null &&
      categoryIds.isEmpty &&
      from == null &&
      to == null;

  /// Any filter besides the text.
  bool get hasFilters =>
      type != null || categoryIds.isNotEmpty || from != null || to != null;

  TransactionSearch copyWith({
    String? text,
    TransactionType? Function()? type,
    Set<String>? categoryIds,
    DateTime? Function()? from,
    DateTime? Function()? to,
  }) => TransactionSearch(
    text: text ?? this.text,
    type: type == null ? this.type : type(),
    categoryIds: categoryIds ?? this.categoryIds,
    from: from == null ? this.from : from(),
    to: to == null ? this.to : to(),
  );

  /// The same text with every filter removed.
  TransactionSearch withoutFilters() => TransactionSearch(text: text);

  @override
  List<Object?> get props => [text, type, categoryIds, from, to];
}
