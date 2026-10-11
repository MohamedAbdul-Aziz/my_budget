import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/assistant_chat.dart';
import '../../domain/entities/assistant_message.dart';

abstract interface class AssistantLocalDataSource {
  Future<List<AssistantChat>> getChats();

  Future<List<AssistantMessage>> getMessages(String chatId);

  /// Creates the chat when [newChatTitle] is given, then adds the question
  /// and its answer, all in one transaction.
  Future<void> saveExchange({
    required String chatId,
    String? newChatTitle,
    required String question,
    required String answer,
  });

  Future<void> deleteChat(String chatId);

  Future<void> deleteAllChats();
}

/// The assistant's chats in SQLite. The tables are phone-only (see
/// [AppDatabase]): no sync columns, never uploaded or backed up.
class AssistantLocalDataSourceImpl implements AssistantLocalDataSource {
  const AssistantLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<AssistantChat>> getChats() => _run('read chats', (db) async {
    final rows = await db.query(
      'assistant_chats',
      orderBy: 'updated_at DESC, created_at DESC',
    );
    return [
      for (final row in rows)
        AssistantChat(
          id: row['id']! as String,
          title: row['title']! as String,
          updatedAt: DateTime.fromMillisecondsSinceEpoch(
            row['updated_at']! as int,
          ),
        ),
    ];
  });

  @override
  Future<List<AssistantMessage>> getMessages(String chatId) =>
      _run('read chat $chatId', (db) async {
        final rows = await db.query(
          'assistant_messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'id',
        );
        return [
          for (final row in rows)
            AssistantMessage(
              role: row['role'] == AssistantRole.user.storageKey
                  ? AssistantRole.user
                  : AssistantRole.assistant,
              text: row['text']! as String,
            ),
        ];
      });

  @override
  Future<void> saveExchange({
    required String chatId,
    String? newChatTitle,
    required String question,
    required String answer,
  }) => _run('save to chat $chatId', (db) async {
    final now = AppDatabase.nowMillis();
    await db.transaction((txn) async {
      if (newChatTitle != null) {
        await txn.insert('assistant_chats', {
          'id': chatId,
          'title': newChatTitle,
          'created_at': now,
          'updated_at': now,
        });
      } else {
        final updated = await txn.update(
          'assistant_chats',
          {'updated_at': now},
          where: 'id = ?',
          whereArgs: [chatId],
        );
        // Deleted from the history while it was open: nothing to add to.
        if (updated == 0) throw NotFoundFailure('chat $chatId');
      }
      for (final (role, text) in [
        (AssistantRole.user, question),
        (AssistantRole.assistant, answer),
      ]) {
        await txn.insert('assistant_messages', {
          'chat_id': chatId,
          'role': role.storageKey,
          'text': text,
          'created_at': now,
        });
      }
    });
  });

  @override
  Future<void> deleteChat(String chatId) => _run(
    'delete chat $chatId',
    (db) => db.delete('assistant_chats', where: 'id = ?', whereArgs: [chatId]),
  );

  @override
  Future<void> deleteAllChats() =>
      _run('delete all chats', (db) => db.delete('assistant_chats'));

  Future<T> _run<T>(String what, Future<T> Function(Database db) action) async {
    try {
      return await action(await _appDatabase.database);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('$what: $error');
    }
  }
}
