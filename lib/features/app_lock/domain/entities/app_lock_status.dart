import 'package:equatable/equatable.dart';

/// Whether the app asks for the phone's fingerprint, face or screen lock
/// before showing anything, and whether it can.
class AppLockStatus extends Equatable {
  const AppLockStatus({
    required this.supported,
    required this.available,
    required this.enabled,
  });

  /// Desktop, or a status that could not be read: no lock.
  const AppLockStatus.off()
    : supported = false,
      available = false,
      enabled = false;

  /// False where the app does not offer a lock (desktop).
  final bool supported;

  /// The phone has a screen lock or biometrics set up to check against.
  final bool available;

  /// The user turned the lock on for this phone.
  final bool enabled;

  /// Whether the app actually locks. A phone whose screen lock was removed
  /// has nothing to check against, so the app opens rather than lock its
  /// owner out.
  bool get isOn => supported && available && enabled;

  AppLockStatus copyWith({bool? enabled}) => AppLockStatus(
    supported: supported,
    available: available,
    enabled: enabled ?? this.enabled,
  );

  @override
  List<Object?> get props => [supported, available, enabled];
}
