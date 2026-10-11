import 'package:equatable/equatable.dart';

/// What the assistant sent back for one question.
class AssistantReply extends Equatable {
  const AssistantReply({required this.answer, this.followUps = const []});

  /// Simple Markdown: bold, lists and short headings.
  final String answer;

  /// Two or three questions the user might ask next; may be empty.
  final List<String> followUps;

  @override
  List<Object?> get props => [answer, followUps];
}
