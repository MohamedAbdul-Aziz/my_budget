import '../../../../core/database/app_database.dart';
import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/sync_report.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasources/sync_local_data_source.dart';
import '../datasources/sync_remote_data_source.dart';

class SyncRepositoryImpl implements SyncRepository {
  const SyncRepositoryImpl({
    required SyncLocalDataSource local,
    required SyncRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final SyncLocalDataSource _local;
  final SyncRemoteDataSource _remote;

  @override
  Future<ApiResult<DateTime?>> lastSyncedAt() => ApiResult.guard(() async {
    final userId = _remote.currentUserId;
    return userId == null ? null : await _local.lastSyncedAt(userId);
  });

  @override
  Future<ApiResult<SyncReport>> backUp({SyncProgress? onProgress}) =>
      ApiResult.guard(() async {
        final userId = await _claimPhone();
        final changes = await _local.pendingChanges();
        final total = changes.length;

        var uploaded = 0;
        onProgress?.call(total == 0 ? 1 : 0);
        await _remote.upload(
          changes,
          userId: userId,
          onUploaded: (count) {
            uploaded += count;
            if (total > 0) onProgress?.call(uploaded / total);
          },
        );
        await _local.markUploaded(changes);

        return _finish(userId, total);
      });

  @override
  Future<ApiResult<SyncReport>> restore({SyncProgress? onProgress}) =>
      ApiResult.guard(() async {
        final userId = await _claimPhone();

        onProgress?.call(0);
        // Downloading is most of the wait; the merge is local and quick.
        final cloud = await _remote.download(
          onProgress: (fraction) => onProgress?.call(fraction * 0.9),
        );
        final applied = await _local.merge(cloud);
        onProgress?.call(1);

        return _finish(userId, applied);
      });

  /// The phone's data carries no owner of its own, so the first account to
  /// sync it claims it. Syncing it with any other account afterwards is
  /// refused: that would upload one person's expenses into someone else's
  /// account, or mix two people's data on this phone.
  Future<String> _claimPhone() async {
    final userId = _remote.currentUserId;
    if (userId == null) {
      throw const SyncFailure(FailureCode.signInRequired);
    }
    final owner = await _local.owner();
    if (owner == null) {
      await _local.setOwner(userId);
    } else if (owner != userId) {
      throw const SyncFailure(FailureCode.syncOtherAccount);
    }
    return userId;
  }

  Future<SyncReport> _finish(String userId, int changes) async {
    // Whole milliseconds, as stored, so the time reported now and the time
    // read back later are the same value.
    final at = DateTime.fromMillisecondsSinceEpoch(AppDatabase.nowMillis());
    await _local.setLastSyncedAt(userId, at);
    return SyncReport(changes: changes, finishedAt: at);
  }
}
