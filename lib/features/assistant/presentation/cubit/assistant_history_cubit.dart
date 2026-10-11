import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../domain/usecases/delete_all_assistant_chats.dart';
import '../../domain/usecases/delete_assistant_chat.dart';
import '../../domain/usecases/get_assistant_chats.dart';
import 'assistant_history_state.dart';

/// The list of saved chats, for as long as the history page is open.
class AssistantHistoryCubit extends Cubit<AssistantHistoryState> {
  AssistantHistoryCubit({
    required GetAssistantChats getChats,
    required DeleteAssistantChat deleteChat,
    required DeleteAllAssistantChats deleteAllChats,
  }) : _getChats = getChats,
       _deleteChat = deleteChat,
       _deleteAllChats = deleteAllChats,
       super(const AssistantHistoryLoading());

  final GetAssistantChats _getChats;
  final DeleteAssistantChat _deleteChat;
  final DeleteAllAssistantChats _deleteAllChats;

  Future<void> load() async {
    final result = await _getChats();
    if (isClosed) return;
    emit(switch (result) {
      Success(:final data) => AssistantHistoryReady(data),
      ResultFailure(:final failure) => AssistantHistoryLoadFailure(
        failure.code,
      ),
    });
  }

  Future<void> delete(String chatId) async {
    await _deleteChat(chatId);
    await load();
  }

  Future<void> deleteAll() async {
    await _deleteAllChats();
    await load();
  }
}
