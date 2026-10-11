import 'dart:math';

import '../../../../core/database/device_settings.dart';
import '../../../../core/error/api_result.dart';
import '../../../data_management/domain/entities/share_anchor.dart';
import '../../domain/entities/assistant_chat.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/entities/assistant_reply.dart';
import '../../domain/entities/assistant_sharing.dart';
import '../../domain/entities/spending_summary.dart';
import '../../domain/repositories/assistant_repository.dart';
import '../datasources/assistant_local_data_source.dart';
import '../datasources/assistant_remote_data_source.dart';
import '../datasources/assistant_share_data_source.dart';
import '../models/assistant_sharing_model.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  AssistantRepositoryImpl({
    required AssistantRemoteDataSource remote,
    required AssistantLocalDataSource local,
    required DeviceSettings deviceSettings,
    AssistantShareDataSource share = const AssistantShareDataSourceImpl(),
  }) : _remote = remote,
       _local = local,
       _deviceSettings = deviceSettings,
       _share = share;

  final AssistantRemoteDataSource _remote;
  final AssistantLocalDataSource _local;
  final DeviceSettings _deviceSettings;
  final AssistantShareDataSource _share;
  final Random _random = Random();

  @override
  Future<ApiResult<AssistantReply>> ask({
    required String question,
    required SpendingSummary summary,
    required List<AssistantMessage> history,
    required String languageCode,
  }) => ApiResult.guard(
    () async => _remote.ask(
      question: question,
      summary: summary,
      history: history,
      languageCode: languageCode,
      deviceId: await _deviceId(),
    ),
  );

  /// This phone's id for the server's daily limit, made on first use: 128
  /// random bits, so it says nothing about the phone or the user.
  Future<String> _deviceId() async {
    final saved = await _deviceSettings.readValue(DeviceSettings.aiDeviceId);
    if (saved != null && RegExp(r'^[0-9a-f]{32}$').hasMatch(saved)) {
      return saved;
    }
    final secure = Random.secure();
    final id = [
      for (var i = 0; i < 16; i++)
        secure.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ].join();
    await _deviceSettings.writeValue(DeviceSettings.aiDeviceId, id);
    return id;
  }

  @override
  Future<ApiResult<void>> shareText(String text, {ShareAnchor? anchor}) =>
      ApiResult.guard(() => _share.shareText(text, anchor: anchor));

  @override
  Future<ApiResult<bool>> hasConsent() =>
      ApiResult.guard(() => _deviceSettings.readFlag(DeviceSettings.aiConsent));

  @override
  Future<ApiResult<void>> setConsent({required bool granted}) =>
      ApiResult.guard(
        () => _deviceSettings.writeFlag(DeviceSettings.aiConsent, on: granted),
      );

  @override
  Future<ApiResult<AssistantSharing>> getSharing() => ApiResult.guard(
    () async => AssistantSharingModel.decode(
      await _deviceSettings.readValue(DeviceSettings.aiSharing),
    ),
  );

  @override
  Future<ApiResult<void>> setSharing(AssistantSharing sharing) =>
      ApiResult.guard(
        () => _deviceSettings.writeValue(
          DeviceSettings.aiSharing,
          AssistantSharingModel.encode(sharing),
        ),
      );

  @override
  Future<ApiResult<List<AssistantChat>>> getChats() =>
      ApiResult.guard(_local.getChats);

  @override
  Future<ApiResult<List<AssistantMessage>>> getMessages(String chatId) =>
      ApiResult.guard(() => _local.getMessages(chatId));

  @override
  Future<ApiResult<String>> saveExchange({
    String? chatId,
    required String title,
    required String question,
    required String answer,
  }) => ApiResult.guard(() async {
    final id = chatId ?? _newId();
    await _local.saveExchange(
      chatId: id,
      newChatTitle: chatId == null ? title : null,
      question: question,
      answer: answer,
    );
    return id;
  });

  @override
  Future<ApiResult<void>> deleteChat(String chatId) =>
      ApiResult.guard(() => _local.deleteChat(chatId));

  @override
  Future<ApiResult<void>> deleteAllChats() =>
      ApiResult.guard(_local.deleteAllChats);

  String _newId() =>
      'chat_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(0xFFFF)}';
}
