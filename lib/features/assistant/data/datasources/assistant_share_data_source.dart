import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/error/failures.dart';
import '../../../data_management/domain/entities/share_anchor.dart';

abstract interface class AssistantShareDataSource {
  Future<void> shareText(String text, {ShareAnchor? anchor});
}

class AssistantShareDataSourceImpl implements AssistantShareDataSource {
  const AssistantShareDataSourceImpl();

  @override
  Future<void> shareText(String text, {ShareAnchor? anchor}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          sharePositionOrigin: anchor == null
              ? null
              : Rect.fromLTWH(
                  anchor.left,
                  anchor.top,
                  anchor.width,
                  anchor.height,
                ),
        ),
      );
    } on PlatformException catch (error) {
      throw FileFailure(FailureCode.shareUnavailable, '$error');
    }
  }
}
