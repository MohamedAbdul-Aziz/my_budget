import '../../../../core/database/device_settings.dart';
import '../../../../core/error/api_result.dart';
import '../../domain/entities/app_lock_prompt.dart';
import '../../domain/repositories/app_lock_repository.dart';
import '../datasources/device_auth_data_source.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  const AppLockRepositoryImpl({
    required DeviceAuthDataSource deviceAuth,
    required DeviceSettings deviceSettings,
  }) : _deviceAuth = deviceAuth,
       _deviceSettings = deviceSettings;

  final DeviceAuthDataSource _deviceAuth;
  final DeviceSettings _deviceSettings;

  @override
  bool get isSupported => _deviceAuth.isSupported;

  @override
  Future<ApiResult<bool>> isAvailable() =>
      ApiResult.guard(_deviceAuth.canAuthenticate);

  @override
  Future<ApiResult<bool>> isEnabled() =>
      ApiResult.guard(() => _deviceSettings.readFlag(DeviceSettings.appLock));

  @override
  Future<ApiResult<void>> setEnabled({required bool enabled}) =>
      ApiResult.guard(
        () => _deviceSettings.writeFlag(DeviceSettings.appLock, on: enabled),
      );

  @override
  Future<ApiResult<bool>> authenticate(AppLockPrompt prompt) =>
      ApiResult.guard(() => _deviceAuth.authenticate(prompt));
}
