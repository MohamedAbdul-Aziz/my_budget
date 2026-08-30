import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../core/error/failures.dart';

/// Hands the Android home screen widget its contents.
///
/// Only one direction travels over this channel. Taps go the other way without
/// it: Android launches the quick-add activity straight from the widget's
/// PendingIntent, with the category on the engine's initial route.
abstract interface class QuickExpenseWidgetChannel {
  /// True on platforms that actually have a home screen widget.
  bool get isSupported;

  Future<void> publish(String payload);
}

class QuickExpenseWidgetChannelImpl implements QuickExpenseWidgetChannel {
  const QuickExpenseWidgetChannelImpl({
    MethodChannel channel = const MethodChannel(channelName),
    TargetPlatform? platform,
  }) : _channel = channel,
       _platform = platform;

  static const String channelName = 'com.example.my_budget/quick_expense';

  final MethodChannel _channel;
  final TargetPlatform? _platform;

  @override
  bool get isSupported => (_platform ?? defaultTargetPlatform) ==
      TargetPlatform.android;

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
}
