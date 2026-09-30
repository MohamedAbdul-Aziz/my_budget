import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../domain/usecases/get_auto_backup.dart';
import '../../domain/usecases/set_auto_backup.dart';
import 'auto_backup_state.dart';

/// Whether this phone backs up on its own. The backups themselves run through
/// `SyncCubit`, so they share its progress and its time of the last sync.
class AutoBackupCubit extends Cubit<AutoBackupState> {
  AutoBackupCubit({
    required GetAutoBackup getAutoBackup,
    required SetAutoBackup setAutoBackup,
  }) : _getAutoBackup = getAutoBackup,
       _setAutoBackup = setAutoBackup,
       super(const AutoBackupLoading());

  final GetAutoBackup _getAutoBackup;
  final SetAutoBackup _setAutoBackup;

  Future<void> load() async {
    emit(switch (await _getAutoBackup()) {
      Success(:final data) => AutoBackupReady(enabled: data),
      // Unreadable counts as off, the safe side for uploads.
      ResultFailure(:final failure) => AutoBackupReady(
        enabled: false,
        error: failure.code,
      ),
    });
  }

  Future<void> setEnabled(bool enabled) async {
    final previous = switch (state) {
      AutoBackupReady(enabled: final current) => current,
      AutoBackupLoading() => false,
    };
    emit(switch (await _setAutoBackup(enabled: enabled)) {
      Success() => AutoBackupReady(enabled: enabled),
      ResultFailure(:final failure) => AutoBackupReady(
        enabled: previous,
        error: failure.code,
      ),
    });
  }
}
