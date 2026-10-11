import 'package:equatable/equatable.dart';

/// A saved conversation with the assistant, kept on this phone only.
class AssistantChat extends Equatable {
  const AssistantChat({
    required this.id,
    required this.title,
    required this.updatedAt,
  });

  final String id;

  /// The chat's first question, shortened.
  final String title;

  /// When the last answer arrived.
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, title, updatedAt];
}
