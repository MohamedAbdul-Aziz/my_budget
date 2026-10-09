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

  /// Another category of the same type already has this name.
  categoryNameTaken,
  categoryProtected,
  currencySymbolInvalid,
  network,
  emailInvalid,
  passwordTooShort,
  invalidCredentials,
  emailTaken,
  emailNotConfirmed,
  codeInvalid,
  tooManyAttempts,
  signInRequired,
  syncOtherAccount,
  syncFailed,
  accountDeletionFailed,
  backupNotRecognized,

  /// Pasted text (an AI chat's answer) that is not importable data.
  pastedNotRecognized,
  backupTooNew,
  backupDamaged,
  fileUnavailable,
  storageFull,
  exportFailed,
  shareUnavailable,
  saveFailed,
  titleRequired,
  titleTooLong,
  dueDayInvalid,
  alreadyPaid,
  personRequired,
  personNameRequired,
  personNameTooLong,
  phoneInvalid,
  transactionSettled,
  nothingToSettle,
  settlementAlreadyLogged,
  questionRequired,
  questionTooLong,

  /// The spending summary could not be made small enough to send.
  summaryTooLarge,

  /// The assistant's server or AI provider failed in a way the user can only
  /// retry later.
  aiUnavailable,

  /// The AI provider is rate limiting everyone for now.
  aiBusy,

  /// This account has asked its questions for the day.
  aiDailyLimit,
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

/// The server could not be reached.
final class NetworkFailure extends Failure {
  const NetworkFailure([String debugMessage = ''])
    : super(FailureCode.network, debugMessage);
}

/// The server refused a sign-in or sign-up.
final class AuthFailure extends Failure {
  const AuthFailure(super.code, [super.debugMessage]);
}

/// A backup or restore could not be completed.
final class SyncFailure extends Failure {
  const SyncFailure(super.code, [super.debugMessage]);
}

/// The AI assistant could not answer.
final class AssistantFailure extends Failure {
  const AssistantFailure(super.code, [super.debugMessage]);
}

/// A file could not be written, read, shared or saved, or is not a usable
/// backup.
final class FileFailure extends Failure {
  const FileFailure(super.code, [super.debugMessage]);
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
