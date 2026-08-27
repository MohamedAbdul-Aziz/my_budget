import 'failures.dart';

/// The contract every repository and use case returns.
///
/// Consumers pattern match exhaustively:
/// ```dart
/// switch (result) {
///   case Success(:final data) => ...,
///   case ResultFailure(:final failure) => ...,
/// }
/// ```
sealed class ApiResult<T> {
  const ApiResult();

  /// Runs [action] and maps any thrown [Failure]/[Object] onto a result.
  static Future<ApiResult<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Failure catch (failure) {
      return ResultFailure(failure);
    } catch (error) {
      return ResultFailure(UnknownFailure('$error'));
    }
  }
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data);

  final T data;
}

final class ResultFailure<T> extends ApiResult<T> {
  const ResultFailure(this.failure);

  final Failure failure;
}

extension ApiResultX<T> on ApiResult<T> {
  /// The value on success, or `null` when the result carries a failure.
  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    ResultFailure() => null,
  };

  /// The failure, or `null` when the result succeeded.
  Failure? get failureOrNull => switch (this) {
    Success() => null,
    ResultFailure(:final failure) => failure,
  };

  bool get isSuccess => this is Success<T>;

  /// Transforms the success value while preserving a failure untouched.
  ApiResult<R> map<R>(R Function(T value) transform) => switch (this) {
    Success(:final data) => Success(transform(data)),
    ResultFailure(:final failure) => ResultFailure<R>(failure),
  };
}
