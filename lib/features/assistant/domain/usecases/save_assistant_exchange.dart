import '../../../../core/error/api_result.dart';
import '../repositories/assistant_repository.dart';

/// Keeps an answered question in the chat's history. Only the question and
/// the answer are kept, never the summary that went with them, and nothing
/// is saved for a question that got no answer.
class SaveAssistantExchange {
  const SaveAssistantExchange(this._repository);

  /// The most of the first question a chat's title shows.
  static const int titleLength = 60;

  final AssistantRepository _repository;

  /// A new chat's title: its first question on one line, shortened.
  static String titleFor(String question) {
    final line = question.trim().replaceAll(RegExp(r'\s+'), ' ');
    final characters = line.runes.toList();
    if (characters.length <= titleLength) return line;
    return '${String.fromCharCodes(characters.take(titleLength - 1)).trimRight()}…';
  }

  /// Answers with the chat's id: a new one when [chatId] is null.
  Future<ApiResult<String>> call({
    String? chatId,
    required String question,
    required String answer,
  }) => _repository.saveExchange(
    chatId: chatId,
    title: titleFor(question),
    question: question.trim(),
    answer: answer,
  );
}
