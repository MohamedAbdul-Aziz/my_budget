import 'package:equatable/equatable.dart';

enum AssistantRole {
  user,
  assistant;

  /// The role name the chat completions API expects.
  String get storageKey => name;
}

/// One line of a conversation with the assistant. Conversations live only in
/// memory: nothing here is ever written to the database.
class AssistantMessage extends Equatable {
  const AssistantMessage({required this.role, required this.text});

  const AssistantMessage.user(this.text) : role = AssistantRole.user;

  const AssistantMessage.assistant(this.text) : role = AssistantRole.assistant;

  final AssistantRole role;
  final String text;

  bool get isUser => role == AssistantRole.user;

  Map<String, String> toJson() => {'role': role.storageKey, 'text': text};

  @override
  List<Object?> get props => [role, text];
}
