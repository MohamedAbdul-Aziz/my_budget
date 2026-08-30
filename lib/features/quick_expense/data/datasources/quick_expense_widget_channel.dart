import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/quick_add_request.dart';

/// Talks to the Android home screen widget.
///
/// The widget lives outside Flutter, so this is the only place that knows how
/// the two sides exchange data.
abstract interface class QuickExpenseWidgetChannel {
  /// True on platforms that actually have a home screen widget.
  bool get isSupported;

  Future<void> publish(String payload);

  Future<QuickAddRequest?> consumeLaunchRequest();

  Stream<QuickAddRequest> get requests;

  Future<void> dispose();
}

class QuickExpenseWidgetChannelImpl implements QuickExpenseWidgetChannel {
  QuickExpenseWidgetChannelImpl({
    MethodChannel? channel,
    TargetPlatform? platform,
  }) : _channel = channel ?? const MethodChannel(channelName),
       _platform = platform ?? defaultTargetPlatform {
    if (isSupported) {
      _channel.setMethodCallHandler(_onCall);
    }
  }

  static const String channelName = 'com.example.my_budget/quick_expense';

  final MethodChannel _channel;
  final TargetPlatform _platform;
  final StreamController<QuickAddRequest> _requests =
      StreamController<QuickAddRequest>.broadcast();

  @override
  bool get isSupported => _platform == TargetPlatform.android;

  @override
  Stream<QuickAddRequest> get requests => _requests.stream;

  @override
  Future<void> publish(String payload) async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<void>('publish', payload);
    } on PlatformException catch (error) {
      throw DatabaseFailure('publish widget: $error');
    } on MissingPluginException {
      // No widget host on this build — nothing to update.
    }
  }

  @override
  Future<QuickAddRequest?> consumeLaunchRequest() async {
    if (!isSupported) return null;
    try {
      final payload = await _channel.invokeMapMethod<String, Object?>(
        'consumeLaunchRequest',
      );
      return payload == null ? null : _toRequest(payload);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  Future<void> _onCall(MethodCall call) async {
    if (call.method != 'openQuickAdd') return;
    final arguments = call.arguments;
    _requests.add(
      arguments is Map
          ? _toRequest(arguments.cast<String, Object?>())
          : const QuickAddRequest(),
    );
  }

  QuickAddRequest _toRequest(Map<String, Object?> payload) {
    final categoryId = payload['categoryId'];
    return QuickAddRequest(
      categoryId: categoryId is String && categoryId.isNotEmpty
          ? categoryId
          : null,
    );
  }

  @override
  Future<void> dispose() async {
    if (isSupported) _channel.setMethodCallHandler(null);
    await _requests.close();
  }
}
