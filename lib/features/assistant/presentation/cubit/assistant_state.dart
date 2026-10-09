import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/assistant_message.dart';

sealed class AssistantState extends Equatable {
  const AssistantState();

  @override
  List<Object?> get props => [];
}

final class AssistantLoading extends AssistantState {
  const AssistantLoading();
}

/// The server counts questions per account, so a guest is asked to sign in.
final class AssistantNeedsSignIn extends AssistantState {
  const AssistantNeedsSignIn();
}

/// Nothing is sent until the user agrees on this phone.
final class AssistantNeedsConsent extends AssistantState {
  const AssistantNeedsConsent({this.failure});

  /// Set when saving the agreement failed.
  final FailureCode? failure;

  @override
  List<Object?> get props => [failure];
}

final class AssistantReady extends AssistantState {
  const AssistantReady({
    this.messages = const [],
    this.sending = false,
    this.failure,
  });

  /// The conversation so far, oldest first. Kept in memory only.
  final List<AssistantMessage> messages;

  /// A question is on its way.
  final bool sending;

  /// Why the last question got no answer; it can be asked again.
  final FailureCode? failure;

  AssistantReady copyWith({
    List<AssistantMessage>? messages,
    bool? sending,
    FailureCode? Function()? failure,
  }) => AssistantReady(
    messages: messages ?? this.messages,
    sending: sending ?? this.sending,
    failure: failure == null ? this.failure : failure(),
  );

  @override
  List<Object?> get props => [messages, sending, failure];
}
