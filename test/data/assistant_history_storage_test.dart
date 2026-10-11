import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/assistant/data/datasources/assistant_local_data_source.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_message.dart';
import 'package:my_budget/features/data_management/data/codecs/backup_codec.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The assistant's chats in the real schema: kept on the phone, never in a
/// backup, and never touched by a restore.
void main() {
  late AppDatabase database;
  late AssistantLocalDataSourceImpl chats;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    database = AppDatabase(inMemory: true);
    chats = AssistantLocalDataSourceImpl(database);
  });

  tearDown(() => database.close());

  Future<void> save(String chatId, String question, {String? title}) =>
      chats.saveExchange(
        chatId: chatId,
        newChatTitle: title,
        question: question,
        answer: 'Answer to $question',
      );

  test('a new phone has no chats', () async {
    expect(await chats.getChats(), isEmpty);
  });

  test(
    'the first answer starts a chat; later ones add to it, in order',
    () async {
      await save('chat_a', 'First?', title: 'First?');
      await save('chat_a', 'Second?');

      final saved = await chats.getChats();
      expect(saved.single.id, 'chat_a');
      expect(saved.single.title, 'First?');
      expect(await chats.getMessages('chat_a'), const [
        AssistantMessage.user('First?'),
        AssistantMessage.assistant('Answer to First?'),
        AssistantMessage.user('Second?'),
        AssistantMessage.assistant('Answer to Second?'),
      ]);
    },
  );

  test('lists the most recently answered chat first', () async {
    await save('chat_a', 'A', title: 'A');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await save('chat_b', 'B', title: 'B');
    expect(
      [for (final c in await chats.getChats()) c.id],
      ['chat_b', 'chat_a'],
    );

    await Future<void>.delayed(const Duration(milliseconds: 5));
    await save('chat_a', 'A again');
    expect(
      [for (final c in await chats.getChats()) c.id],
      ['chat_a', 'chat_b'],
    );
  });

  test('adding to a chat that was deleted fails and saves nothing', () async {
    await expectLater(save('gone', 'Hello?'), throwsA(isA<NotFoundFailure>()));
    final db = await database.database;
    expect(await db.query('assistant_messages'), isEmpty);
  });

  test('deleting a chat takes its messages with it', () async {
    await save('chat_a', 'A', title: 'A');
    await save('chat_b', 'B', title: 'B');

    await chats.deleteChat('chat_a');

    expect([for (final c in await chats.getChats()) c.id], ['chat_b']);
    final db = await database.database;
    final left = await db.query('assistant_messages', columns: ['chat_id']);
    expect({for (final row in left) row['chat_id']}, {'chat_b'});
  });

  test('delete all leaves nothing behind', () async {
    await save('chat_a', 'A', title: 'A');
    await save('chat_b', 'B', title: 'B');

    await chats.deleteAllChats();

    expect(await chats.getChats(), isEmpty);
    final db = await database.database;
    expect(await db.query('assistant_messages'), isEmpty);
  });

  test('never travels with a backup, and a restore never changes it', () async {
    final records = LocalRecords(database);
    await save('chat_a', 'Where can I save?', title: 'Where can I save?');

    final file = BackupCodec.encode(
      await records.readAll(),
      exportedAt: DateTime(2026, 10, 10),
    );
    expect(file, isNot(contains('Where can I save')));
    expect(file, isNot(contains('assistant')));
    final pending = BackupCodec.encode(
      await records.readPending(),
      exportedAt: DateTime(2026, 10, 10),
    );
    expect(pending, isNot(contains('Where can I save')));

    await records.replaceAll(BackupCodec.decode(file).records);
    expect((await chats.getChats()).single.id, 'chat_a');
    expect(await chats.getMessages('chat_a'), hasLength(2));
  });
}
