import '../../../../core/error/api_result.dart';
import '../../../data_management/domain/entities/share_anchor.dart';
import '../entities/assistant_chat.dart';
import '../entities/assistant_message.dart';
import '../entities/assistant_reply.dart';
import '../entities/assistant_sharing.dart';
import '../entities/spending_summary.dart';

abstract interface class AssistantRepository {
  /// Sends [question] with the [summary] and the last few [history] messages
  /// to the assistant's server, and answers with its reply. No account is
  /// needed: the server counts questions per account, or per device for a
  /// guest, and refuses past its daily limit.
  Future<ApiResult<AssistantReply>> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
  });

  /// Whether the user agreed, on this phone, to send their summary out.
  Future<ApiResult<bool>> hasConsent();

  Future<ApiResult<void>> setConsent({required bool granted});

  /// What the user lets the assistant see; the default until changed.
  Future<ApiResult<AssistantSharing>> getSharing();

  Future<ApiResult<void>> setSharing(AssistantSharing sharing);

  /// Saved chats, the most recently answered first.
  Future<ApiResult<List<AssistantChat>>> getChats();

  /// A chat's messages, oldest first.
  Future<ApiResult<List<AssistantMessage>>> getMessages(String chatId);

  /// Saves an answered question. Starts a chat titled [title] when [chatId]
  /// is null, and answers with the chat's id either way.
  Future<ApiResult<String>> saveExchange({
    String? chatId,
    required String title,
    required String question,
    required String answer,
  });

  Future<ApiResult<void>> deleteChat(String chatId);

  Future<ApiResult<void>> deleteAllChats();

  Future<ApiResult<void>> shareText(String text, {ShareAnchor? anchor});
}
