import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../data_management/domain/entities/share_anchor.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/entities/assistant_sharing.dart';
import '../../domain/usecases/ask_assistant.dart';
import '../../domain/usecases/get_assistant_chat_messages.dart';
import '../../domain/usecases/get_assistant_consent.dart';
import '../../domain/usecases/get_assistant_sharing.dart';
import '../../domain/usecases/save_assistant_exchange.dart';
import '../../domain/usecases/set_assistant_consent.dart';
import '../../domain/usecases/set_assistant_sharing.dart';
import '../../domain/usecases/share_assistant_answer.dart';
import 'assistant_state.dart';

/// One conversation with the assistant, for as long as its page is open.
class AssistantCubit extends Cubit<AssistantState> {
  AssistantCubit({
    required GetAssistantConsent getConsent,
    required SetAssistantConsent setConsent,
    required AskAssistant askAssistant,
    required SaveAssistantExchange saveExchange,
    required GetAssistantChatMessages getChatMessages,
    required GetAssistantSharing getSharing,
    required SetAssistantSharing setSharing,
    required ShareAssistantAnswer shareAnswer,
  }) : _getConsent = getConsent,
       _setConsent = setConsent,
       _askAssistant = askAssistant,
       _saveExchange = saveExchange,
       _getChatMessages = getChatMessages,
       _getSharing = getSharing,
       _setSharing = setSharing,
       _shareAnswer = shareAnswer,
       super(const AssistantLoading());

  final GetAssistantConsent _getConsent;
  final SetAssistantConsent _setConsent;
  final AskAssistant _askAssistant;
  final SaveAssistantExchange _saveExchange;
  final GetAssistantChatMessages _getChatMessages;
  final GetAssistantSharing _getSharing;
  final SetAssistantSharing _setSharing;
  final ShareAssistantAnswer _shareAnswer;

  /// What the user lets the assistant see; read once on [load].
  AssistantSharing _sharing = AssistantSharing.defaults;

  /// Bumped whenever another conversation is put on screen, so an answer
  /// that arrives afterwards is saved to its own chat but not shown here.
  int _conversation = 0;

  /// No account is needed: the server counts a guest's questions by a
  /// device id instead.
  Future<void> load() async {
    // Unreadable is treated as not agreed, and unreadable sharing as the
    // default: neither failure can send more than the user chose.
    final agreed = (await _getConsent()).dataOrNull ?? false;
    _sharing = (await _getSharing()).dataOrNull ?? AssistantSharing.defaults;
    if (!agreed) {
      emit(const AssistantNeedsConsent());
    } else if (state is! AssistantReady) {
      emit(AssistantReady(sharing: _sharing));
    }
  }

  Future<void> grantConsent() async {
    switch (await _setConsent(granted: true)) {
      case Success():
        emit(AssistantReady(sharing: _sharing));
      case ResultFailure(:final failure):
        emit(AssistantNeedsConsent(failure: failure.code));
    }
  }

  /// Withdraws the agreement and forgets the conversation.
  Future<void> revokeConsent() async {
    await _setConsent(granted: false);
    emit(const AssistantNeedsConsent());
  }

  /// Clears the screen for a fresh conversation. The current one is already
  /// saved, as far as it was answered.
  void newChat() {
    if (state case AssistantReady(sending: false)) {
      _conversation++;
      emit(AssistantReady(sharing: _sharing));
    }
  }

  /// Applies [change] to the latest choices; see [updateSharing].
  Future<void> changeSharing(
    AssistantSharing Function(AssistantSharing current) change,
  ) => updateSharing(change(_sharing));

  /// Changes what goes out from the next question on, and keeps the choice
  /// on this phone.
  Future<void> updateSharing(AssistantSharing sharing) async {
    _sharing = sharing;
    final current = state;
    if (current is AssistantReady) emit(current.copyWith(sharing: sharing));
    await _setSharing(sharing);
  }

  /// Puts a saved chat back on screen, ready to carry on.
  Future<void> openChat(String chatId) async {
    if (state case AssistantReady(sending: true)) return;
    if (state is! AssistantReady) return;
    final conversation = ++_conversation;
    final result = await _getChatMessages(chatId);
    if (isClosed || conversation != _conversation) return;
    switch (result) {
      case Success(:final data):
        emit(AssistantReady(sharing: _sharing, chatId: chatId, messages: data));
      case ResultFailure(:final failure):
        emit(AssistantReady(sharing: _sharing, failure: failure.code));
    }
  }

  /// [labelOf], [currency] and [languageCode] come from the page, which
  /// knows how the user reads their categories and money.
  Future<void> ask(
    String question, {
    required String Function(ExpenseCategory) labelOf,
    required String currency,
    required String languageCode,
  }) async {
    final current = state;
    if (current is! AssistantReady || current.sending) return;
    if (AskAssistant.validate(question) case final code?) {
      emit(current.copyWith(failure: () => code));
      return;
    }

    final history = current.messages;
    final conversation = _conversation;
    emit(
      current.copyWith(
        messages: [...history, AssistantMessage.user(question.trim())],
        sending: true,
        followUps: const [],
        failure: () => null,
      ),
    );

    final result = await _askAssistant(
      question: question,
      history: history,
      labelOf: labelOf,
      currency: currency,
      languageCode: languageCode,
      sharing: current.sharing,
    );
    if (result case Success(:final data)) {
      final chatId = await _save(current.chatId, question, data.answer);
      if (isClosed || conversation != _conversation) return;
      final asked = state;
      if (asked is! AssistantReady) return;
      emit(
        asked.copyWith(
          chatId: chatId,
          messages: [
            ...asked.messages,
            AssistantMessage.assistant(data.answer),
          ],
          followUps: data.followUps,
          sending: false,
        ),
      );
      return;
    }
    if (isClosed || conversation != _conversation) return;
    final asked = state;
    if (asked is! AssistantReady) return;

    if (result case ResultFailure(:final failure)) {
      emit(asked.copyWith(sending: false, failure: () => failure.code));
    }
  }

  /// Opens the phone's share sheet with an answer; the reason when it could
  /// not open.
  Future<FailureCode?> share(String text, {ShareAnchor? anchor}) async =>
      (await _shareAnswer(text, anchor: anchor)).failureOrNull?.code;

  /// Saves the answered question to [chatId], or to a new chat when there is
  /// none yet or it was deleted meanwhile. A failed save still shows the
  /// answer; it only goes unsaved.
  Future<String?> _save(String? chatId, String question, String answer) async {
    var result = await _saveExchange(
      chatId: chatId,
      question: question,
      answer: answer,
    );
    if (chatId != null && result.failureOrNull is NotFoundFailure) {
      result = await _saveExchange(question: question, answer: answer);
    }
    return result.dataOrNull ?? chatId;
  }

  /// Asks the last unanswered question again.
  Future<void> retry({
    required String Function(ExpenseCategory) labelOf,
    required String currency,
    required String languageCode,
  }) async {
    final current = state;
    if (current is! AssistantReady || current.sending) return;
    final last = current.messages.lastOrNull;
    if (last == null || !last.isUser) return;
    emit(
      current.copyWith(
        messages: current.messages.sublist(0, current.messages.length - 1),
      ),
    );
    await ask(
      last.text,
      labelOf: labelOf,
      currency: currency,
      languageCode: languageCode,
    );
  }
}
