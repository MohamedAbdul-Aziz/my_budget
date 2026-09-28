import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../sync/domain/repositories/sync_repository.dart';
import '../repositories/auth_repository.dart';

/// Permanently deletes the signed-in account together with its cloud backup.
/// The records on this phone stay, and the app carries on without an account.
class DeleteAccount {
  const DeleteAccount({
    required AuthRepository authRepository,
    required SyncRepository syncRepository,
  }) : _authRepository = authRepository,
       _syncRepository = syncRepository;

  final AuthRepository _authRepository;
  final SyncRepository _syncRepository;

  Future<ApiResult<void>> call() async {
    final user = _authRepository.currentUser;
    if (user == null) {
      return const ResultFailure(AuthFailure(FailureCode.signInRequired));
    }

    final deleted = await _authRepository.deleteAccount();
    if (deleted is ResultFailure<void>) return deleted;

    // The account is gone whatever happens next. Unlinking the phone's data
    // is local bookkeeping; if it failed, the only effect is that a later
    // backup to a new account is refused as "another account", so it does
    // not turn a completed deletion into a reported failure.
    await _syncRepository.forgetAccount(user.id);
    return const Success(null);
  }
}
