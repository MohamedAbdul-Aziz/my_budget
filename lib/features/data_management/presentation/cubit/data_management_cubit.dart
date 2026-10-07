import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../domain/entities/export_format.dart';
import '../../domain/entities/export_locale.dart';
import '../../domain/entities/import_mode.dart';
import '../../domain/entities/share_anchor.dart';
import '../../domain/usecases/choose_backup.dart';
import '../../domain/usecases/export_data.dart';
import '../../domain/usecases/import_backup.dart';
import '../../domain/usecases/preview_pasted_backup.dart';
import '../../domain/usecases/save_files.dart';
import '../../domain/usecases/share_files.dart';
import 'data_management_state.dart';

/// Exports, sharing, saving and importing of files the user keeps. Needs no
/// account and no connection.
class DataManagementCubit extends Cubit<DataManagementState> {
  DataManagementCubit({
    required ExportData exportData,
    required ShareFiles shareFiles,
    required SaveFiles saveFiles,
    required ChooseBackup chooseBackup,
    required PreviewPastedBackup previewPastedBackup,
    required ImportBackup importBackup,
  }) : _exportData = exportData,
       _shareFiles = shareFiles,
       _saveFiles = saveFiles,
       _chooseBackup = chooseBackup,
       _previewPastedBackup = previewPastedBackup,
       _importBackup = importBackup,
       super(const DataIdle());

  final ExportData _exportData;
  final ShareFiles _shareFiles;
  final SaveFiles _saveFiles;
  final ChooseBackup _chooseBackup;
  final PreviewPastedBackup _previewPastedBackup;
  final ImportBackup _importBackup;

  Future<void> export(ExportFormat format, ExportLocale locale) async {
    if (state.isBusy) return;

    emit(const DataWorking(DataTask.export));
    final result = await _exportData(
      format,
      locale,
      onProgress: (fraction) => _progress(DataTask.export, fraction),
    );
    emit(switch (result) {
      Success(:final data) => DataExportReady(data),
      ResultFailure(:final failure) => DataFailed(failure.code),
    });
  }

  Future<void> share({ShareAnchor? anchor}) async {
    final current = state;
    if (current is! DataExportReady) return;

    final result = await _shareFiles(current.files, anchor: anchor);
    // Whatever the user did in the share sheet, the system confirmed it.
    emit(switch (result) {
      Success() => const DataIdle(),
      ResultFailure(:final failure) => DataFailed(failure.code),
    });
  }

  Future<void> save() async {
    final current = state;
    if (current is! DataExportReady) return;

    final result = await _saveFiles(current.files);
    emit(switch (result) {
      Success(data: true) => const DataSaved(),
      // Cancelled: not an error.
      Success() => const DataIdle(),
      ResultFailure(:final failure) => DataFailed(failure.code),
    });
  }

  /// Picks a backup and checks it. Nothing is imported until
  /// [importBackup] confirms it.
  Future<void> chooseBackup() async {
    if (state.isBusy) return;

    emit(const DataWorking(DataTask.import));
    final result = await _chooseBackup();
    emit(switch (result) {
      Success(data: final backup?) => DataImportReview(backup),
      // Cancelled: not an error.
      Success() => const DataIdle(),
      ResultFailure(:final failure) => DataFailed(failure.code),
    });
  }

  /// Checks pasted text, such as an AI chat's reply to the import prompt,
  /// and asks for the same confirmation as a chosen file.
  Future<void> pasteBackup(String text) async {
    if (state.isBusy) return;

    emit(const DataWorking(DataTask.import));
    final result = await _previewPastedBackup(text);
    emit(switch (result) {
      Success(:final data) => DataImportReview(data),
      ResultFailure(:final failure) => DataFailed(failure.code),
    });
  }

  Future<void> importBackup(ImportMode mode) async {
    final current = state;
    if (current is! DataImportReview) return;

    emit(const DataWorking(DataTask.import));
    final result = await _importBackup(
      current.backup,
      mode,
      onProgress: (fraction) => _progress(DataTask.import, fraction),
    );
    emit(switch (result) {
      Success(:final data) => DataImported(data),
      ResultFailure(:final failure) => DataFailed(failure.code),
    });
  }

  /// The user closed the share-or-save choice or the import confirmation.
  void dismiss() {
    if (state is DataExportReady || state is DataImportReview) {
      emit(const DataIdle());
    }
  }

  void _progress(DataTask task, double fraction) {
    if (!isClosed && state is DataWorking) {
      emit(DataWorking(task, progress: fraction));
    }
  }
}
