import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// What happened, not what to say about it.
enum NoticeCode {
  expenseDeleted,
  expenseRestored,
  categoryAdded,
  categoryUpdated,
  categoryDeleted,
  categoryDeletedWithMoves,
  failure,
}

/// A one-shot event a cubit hands to the UI, which renders it as a snackbar in
/// the current language.
///
/// Each instance carries a unique [id] so two identical notices in a row are
/// still two distinct states and `BlocListener` fires for both.
class UiNotice extends Equatable {
  UiNotice(this.code, {this.name, this.count, this.failure}) : id = _next();

  UiNotice.from(Failure failure)
    : this(NoticeCode.failure, failure: failure);

  static int _counter = 0;

  static int _next() => ++_counter;

  final NoticeCode code;

  /// Category name, for the notices that mention one.
  final String? name;

  /// How many expenses were moved by a category deletion.
  final int? count;

  /// Set when [code] is [NoticeCode.failure].
  final Failure? failure;

  final int id;

  @override
  List<Object?> get props => [id];
}
