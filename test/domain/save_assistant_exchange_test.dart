import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/assistant/domain/usecases/save_assistant_exchange.dart';

import '../presentation/fakes.dart';

void main() {
  group('titleFor', () {
    test('keeps a short question as it is, on one line', () {
      expect(
        SaveAssistantExchange.titleFor('  Where can I\nsave?  '),
        'Where can I save?',
      );
    });

    test('shortens a long one to 60 characters with an ellipsis', () {
      final title = SaveAssistantExchange.titleFor('a' * 80);
      expect(title.runes.length, SaveAssistantExchange.titleLength);
      expect(title, endsWith('…'));
    });

    test('never splits a character outside the basic plane', () {
      final title = SaveAssistantExchange.titleFor('💸' * 70);
      expect(title, '${'💸' * 59}…');
    });
  });

  test('the first save starts a chat titled by the question; later saves '
      'add to it', () async {
    final repository = FakeAssistantRepository();
    final save = SaveAssistantExchange(repository);

    final id = (await save(question: ' How much? ', answer: '40')).dataOrNull!;
    final again = (await save(
      chatId: id,
      question: 'And food?',
      answer: '20',
    )).dataOrNull!;

    expect(again, id);
    final saved = repository.chats[id]!;
    expect(saved.chat.title, 'How much?');
    expect(saved.messages.map((m) => m.text), [
      'How much?',
      '40',
      'And food?',
      '20',
    ]);
  });
}
