import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/assistant_chat.dart';

sealed class AssistantHistoryState extends Equatable {
  const AssistantHistoryState();

  @override
  List<Object?> get props => [];
}

final class AssistantHistoryLoading extends AssistantHistoryState {
  const AssistantHistoryLoading();
}

final class AssistantHistoryReady extends AssistantHistoryState {
  const AssistantHistoryReady(this.chats);

  /// Most recently answered first.
  final List<AssistantChat> chats;

  @override
  List<Object?> get props => [chats];
}

final class AssistantHistoryLoadFailure extends AssistantHistoryState {
  const AssistantHistoryLoadFailure(this.code);

  final FailureCode code;

  @override
  List<Object?> get props => [code];
}
