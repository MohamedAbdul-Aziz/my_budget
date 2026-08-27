/// Identifies a failure independently of any wording.
///
/// The presentation layer turns a code into a localized sentence, so no
/// user-facing English lives in the data or domain layers.
enum FailureCode {
  database,
  notFound,
  unknown,
  amountRequired,
  amountTooLarge,
  amountInvalid,
  categoryRequired,
  categoryNameRequired,
  categoryNameTooLong,
  categoryProtected,
  currencySymbolInvalid,
}

/// Typed failures produced by the data layer and surfaced through `ApiResult`.
///
/// Pure Dart: no Flutter imports, so the domain layer can depend on it freely.
sealed class Failure {
  const Failure(this.code, [this.debugMessage = '']);

  final FailureCode code;

  /// Developer-facing detail (SQL error text and the like). Never shown to the
  /// user — the UI renders [code] instead.
  final String debugMessage;

  @override
  String toString() => '$runtimeType($code, $debugMessage)';
}

/// A local storage (SQLite) operation failed.
final class DatabaseFailure extends Failure {
  const DatabaseFailure([String debugMessage = ''])
    : super(FailureCode.database, debugMessage);
}

/// The requested record does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([String debugMessage = ''])
    : super(FailureCode.notFound, debugMessage);
}

/// User input did not satisfy a business rule.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.code, [super.debugMessage]);
}

/// Anything the data layer could not classify.
final class UnknownFailure extends Failure {
  const UnknownFailure([String debugMessage = ''])
    : super(FailureCode.unknown, debugMessage);
}
