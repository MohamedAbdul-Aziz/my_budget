import '../../../../core/error/api_result.dart';
import '../entities/sync_report.dart';

/// How far a running backup or restore has got, from 0 to 1.
typedef SyncProgress = void Function(double fraction);

/// Copies the phone's categories, expenses and settings to the signed-in
/// user's account and back. Records are matched by id, so repeating either
/// direction never duplicates anything, and when a record changed in both
/// places the newer change wins.
abstract interface class SyncRepository {
  /// When the signed-in user last backed up or restored on this phone; null
  /// if never, or if nobody is signed in.
  Future<ApiResult<DateTime?>> lastSyncedAt();

  /// Uploads every change made on this phone since its last backup, deletes
  /// included.
  Future<ApiResult<SyncReport>> backUp({SyncProgress? onProgress});

  /// Merges the account's copy into this phone. Nothing that exists only on
  /// the phone is removed.
  Future<ApiResult<SyncReport>> restore({SyncProgress? onProgress});

  /// The account [userId] was deleted along with its cloud copy. Unlinks this
  /// phone's data from it, so a different account can back everything up
  /// from scratch. The phone's own records are kept.
  Future<ApiResult<void>> forgetAccount(String userId);

  /// Whether this phone backs up on its own; a preference of this phone
  /// alone, never synced.
  Future<ApiResult<bool>> autoBackupEnabled();

  Future<ApiResult<void>> setAutoBackup({required bool enabled});

  /// Whether this phone has changes its last backup does not include.
  Future<ApiResult<bool>> hasPendingChanges();
}
