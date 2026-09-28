import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../domain/entities/sync_report.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../domain/usecases/back_up_data.dart';
import '../../domain/usecases/get_last_synced_at.dart';
import '../../domain/usecases/restore_data.dart';
import 'sync_state.dart';

/// Backup and restore for the signed-in user. Only ever started by the user:
/// nothing syncs on its own.
class SyncCubit extends Cubit<SyncState> {
  SyncCubit({
    required GetLastSyncedAt getLastSyncedAt,
    required BackUpData backUpData,
    required RestoreData restoreData,
  }) : _getLastSyncedAt = getLastSyncedAt,
       _backUpData = backUpData,
       _restoreData = restoreData,
       super(const SyncIdle());

  final GetLastSyncedAt _getLastSyncedAt;
  final BackUpData _backUpData;
  final RestoreData _restoreData;

  /// Reads the last sync time of whoever is signed in now. Called when the
  /// backup controls appear, so it follows account changes.
  Future<void> load() async {
    if (state.isRunning) return;
    final result = await _getLastSyncedAt();
    if (state.isRunning) return;
    emit(SyncIdle(lastSyncedAt: result.dataOrNull));
  }

  Future<void> backUp() => _run(
    SyncKind.backup,
    (onProgress) => _backUpData(onProgress: onProgress),
  );

  Future<void> restore() => _run(
    SyncKind.restore,
    (onProgress) => _restoreData(onProgress: onProgress),
  );

  Future<void> _run(
    SyncKind kind,
    Future<ApiResult<SyncReport>> Function(SyncProgress onProgress) task,
  ) async {
    if (state.isRunning) return;

    final previous = state.lastSyncedAt;
    emit(SyncRunning(kind, lastSyncedAt: previous));
    final result = await task((fraction) {
      if (!isClosed) {
        emit(SyncRunning(kind, progress: fraction, lastSyncedAt: previous));
      }
    });

    switch (result) {
      case Success(:final data):
        emit(SyncSucceeded(kind, data));
      case ResultFailure(:final failure):
        emit(SyncFailed(kind, failure.code, lastSyncedAt: previous));
    }
  }
}
