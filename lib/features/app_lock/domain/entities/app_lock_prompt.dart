import 'package:equatable/equatable.dart';

/// The words on the phone's own fingerprint, face or screen-lock prompt,
/// already in the user's language. The domain never writes user-facing text,
/// so the presentation layer supplies them.
class AppLockPrompt extends Equatable {
  const AppLockPrompt({
    required this.reason,
    required this.title,
    required this.cancel,
  });

  /// Why the app is asking.
  final String reason;
  final String title;
  final String cancel;

  @override
  List<Object?> get props => [reason, title, cancel];
}
