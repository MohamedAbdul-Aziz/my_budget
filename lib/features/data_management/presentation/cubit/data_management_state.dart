import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/backup_preview.dart';
import '../../domain/entities/exported_file.dart';

enum DataTask { export, import }

sealed class DataManagementState extends Equatable {
  const DataManagementState();

  bool get isBusy => this is DataWorking;

  @override
  List<Object?> get props => [];
}

final class DataIdle extends DataManagementState {
  const DataIdle();
}

final class DataWorking extends DataManagementState {
  const DataWorking(this.task, {this.progress = 0});

  final DataTask task;

  /// From 0 to 1.
  final double progress;

  @override
  List<Object?> get props => [task, progress];
}

/// An export is written; the user picks where it goes.
final class DataExportReady extends DataManagementState {
  const DataExportReady(this.files);

  final List<ExportedFile> files;

  @override
  List<Object?> get props => [files];
}

/// A backup is picked and checked; nothing changes until the user confirms.
final class DataImportReview extends DataManagementState {
  const DataImportReview(this.backup);

  final BackupPreview backup;

  @override
  List<Object?> get props => [backup];
}

final class DataSaved extends DataManagementState {
  const DataSaved();
}

final class DataImported extends DataManagementState {
  const DataImported(this.changes);

  /// Records added, updated or deleted. 0 when the phone already had
  /// everything in the backup.
  final int changes;

  @override
  List<Object?> get props => [changes];
}

final class DataFailed extends DataManagementState {
  const DataFailed(this.error);

  /// The UI turns it into a sentence.
  final FailureCode error;

  @override
  List<Object?> get props => [error];
}
