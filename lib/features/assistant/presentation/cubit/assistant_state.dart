import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/entities/assistant_sharing.dart';

sealed class AssistantState extends Equatable {
  const AssistantState();

  @override
  List<Object?> get props => [];
}

final class AssistantLoading extends AssistantState {
  const AssistantLoading();
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
    this.sharing = AssistantSharing.defaults,
    this.chatId,
    this.messages = const [],
    this.followUps = const [],
    this.sending = false,
    this.failure,
  });

  /// What goes out with each question.
  final AssistantSharing sharing;

  /// The saved chat this conversation belongs to; null until its first
  /// answer, which starts it.
  final String? chatId;

  /// The conversation so far, oldest first. Answered questions are saved on
  /// the phone; one still waiting or failed lives only here.
  final List<AssistantMessage> messages;

  /// Questions the assistant suggested after its last answer; cleared as
  /// soon as another question is asked. Never saved.
  final List<String> followUps;

  /// A question is on its way.
  final bool sending;

  /// Why the last question got no answer; it can be asked again.
  final FailureCode? failure;

  AssistantReady copyWith({
    AssistantSharing? sharing,
    String? chatId,
    List<AssistantMessage>? messages,
    List<String>? followUps,
    bool? sending,
    FailureCode? Function()? failure,
  }) => AssistantReady(
    sharing: sharing ?? this.sharing,
    chatId: chatId ?? this.chatId,
    messages: messages ?? this.messages,
    followUps: followUps ?? this.followUps,
    sending: sending ?? this.sending,
    failure: failure == null ? this.failure : failure(),
  );

  @override
  List<Object?> get props => [
    sharing,
    chatId,
    messages,
    followUps,
    sending,
    failure,
  ];
}
