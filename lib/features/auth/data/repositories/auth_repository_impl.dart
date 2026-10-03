import '../../../../core/error/api_result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  AppUser? get currentUser => _remoteDataSource.currentUser;

  @override
  Stream<AppUser?> get userChanges => _remoteDataSource.userChanges;

  @override
  Future<ApiResult<AppUser>> signIn({
    required String email,
    required String password,
  }) => ApiResult.guard(
    () => _remoteDataSource.signIn(email: email, password: password),
  );

  @override
  Future<ApiResult<AppUser?>> signUp({
    required String email,
    required String password,
  }) => ApiResult.guard(
    () => _remoteDataSource.signUp(email: email, password: password),
  );

  @override
  Future<ApiResult<AppUser>> confirmSignUp({
    required String email,
    required String code,
  }) => ApiResult.guard(
    () => _remoteDataSource.confirmSignUp(email: email, code: code),
  );

  @override
  Future<ApiResult<void>> resendSignUpCode({required String email}) =>
      ApiResult.guard(() => _remoteDataSource.resendSignUpCode(email: email));

  @override
  Future<ApiResult<void>> sendPasswordReset({required String email}) =>
      ApiResult.guard(() => _remoteDataSource.sendPasswordReset(email: email));

  @override
  Future<ApiResult<AppUser>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => ApiResult.guard(
    () => _remoteDataSource.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    ),
  );

  @override
  Future<ApiResult<void>> deleteAccount() =>
      ApiResult.guard(_remoteDataSource.deleteAccount);

  @override
  Future<ApiResult<void>> signOut() =>
      ApiResult.guard(_remoteDataSource.signOut);
}
