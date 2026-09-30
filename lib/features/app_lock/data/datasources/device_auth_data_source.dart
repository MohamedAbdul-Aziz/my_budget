import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

import '../../domain/entities/app_lock_prompt.dart';

/// The phone's own fingerprint, face or screen-lock check.
abstract interface class DeviceAuthDataSource {
  /// True on the phones the lock is offered on.
  bool get isSupported;

  /// The phone has a screen lock or biometrics to check against.
  Future<bool> canAuthenticate();

  Future<bool> authenticate(AppLockPrompt prompt);
}

class DeviceAuthDataSourceImpl implements DeviceAuthDataSource {
  DeviceAuthDataSourceImpl({
    LocalAuthentication? auth,
    TargetPlatform? platform,
  }) : _auth = auth ?? LocalAuthentication(),
       _platform = platform;

  final LocalAuthentication _auth;
  final TargetPlatform? _platform;

  @override
  bool get isSupported {
    final platform = _platform ?? defaultTargetPlatform;
    return !kIsWeb &&
        (platform == TargetPlatform.android || platform == TargetPlatform.iOS);
  }

  @override
  Future<bool> canAuthenticate() async =>
      isSupported && await _auth.isDeviceSupported();

  /// Biometrics when set up, otherwise the phone's PIN, pattern or passcode.
  @override
  Future<bool> authenticate(AppLockPrompt prompt) async {
    if (!isSupported) return true;
    try {
      return await _auth.authenticate(
        localizedReason: prompt.reason,
        authMessages: [
          AndroidAuthMessages(
            signInTitle: prompt.title,
            cancelButton: prompt.cancel,
          ),
          IOSAuthMessages(cancelButton: prompt.cancel),
        ],
        // A call or a notification interrupting the prompt asks again
        // instead of leaving the app locked with nothing on screen.
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (error) {
      // Cancelled, timed out, too many tries: still locked, and the lock
      // screen offers to try again.
      debugPrint('app lock: ${error.code}');
      return false;
    }
  }
}
