import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/usecases/ask_assistant.dart';
import '../../domain/usecases/get_assistant_consent.dart';
import '../../domain/usecases/set_assistant_consent.dart';
import 'assistant_state.dart';

/// One conversation with the assistant, for as long as its page is open.
class AssistantCubit extends Cubit<AssistantState> {
  AssistantCubit({
    required GetCurrentUser getCurrentUser,
    required GetAssistantConsent getConsent,
    required SetAssistantConsent setConsent,
    required AskAssistant askAssistant,
  }) : _getCurrentUser = getCurrentUser,
       _getConsent = getConsent,
       _setConsent = setConsent,
       _askAssistant = askAssistant,
       super(const AssistantLoading());

  final GetCurrentUser _getCurrentUser;
  final GetAssistantConsent _getConsent;
  final SetAssistantConsent _setConsent;
  final AskAssistant _askAssistant;

  /// Also called when the user signs in or out while the page is open. A
  /// conversation already under way is kept.
  Future<void> load() async {
    if (_getCurrentUser() == null) {
      emit(const AssistantNeedsSignIn());
      return;
    }
    // Unreadable is treated as not agreed: nothing is sent without a yes.
    final agreed = (await _getConsent()).dataOrNull ?? false;
    if (!agreed) {
      emit(const AssistantNeedsConsent());
    } else if (state is! AssistantReady) {
      emit(const AssistantReady());
    }
  }

  Future<void> grantConsent() async {
    switch (await _setConsent(granted: true)) {
      case Success():
        emit(const AssistantReady());
      case ResultFailure(:final failure):
        emit(AssistantNeedsConsent(failure: failure.code));
    }
  }

  /// Withdraws the agreement and forgets the conversation.
  Future<void> revokeConsent() async {
    await _setConsent(granted: false);
    emit(const AssistantNeedsConsent());
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
    emit(
      current.copyWith(
        messages: [...history, AssistantMessage.user(question.trim())],
        sending: true,
        failure: () => null,
      ),
    );

    final result = await _askAssistant(
      question: question,
      history: history,
      labelOf: labelOf,
      currency: currency,
      languageCode: languageCode,
    );
    if (isClosed) return;
    final asked = state;
    if (asked is! AssistantReady) return;

    switch (result) {
      case Success(:final data):
        emit(
          asked.copyWith(
            messages: [...asked.messages, AssistantMessage.assistant(data)],
            sending: false,
          ),
        );
      case ResultFailure(:final failure)
          when failure.code == FailureCode.signInRequired:
        emit(const AssistantNeedsSignIn());
      case ResultFailure(:final failure):
        emit(asked.copyWith(sending: false, failure: () => failure.code));
    }
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
