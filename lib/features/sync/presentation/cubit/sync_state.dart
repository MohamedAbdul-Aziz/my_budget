import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/sync_report.dart';

/// [automatic] is a backup the app started on its own: it shows no success
/// message, only the new time of the last sync.
enum SyncKind { backup, restore, automatic }

sealed class SyncState extends Equatable {
  const SyncState({this.lastSyncedAt});

  /// When the signed-in user last finished a backup or restore on this phone.
  final DateTime? lastSyncedAt;

  bool get isRunning => this is SyncRunning;

  @override
  List<Object?> get props => [lastSyncedAt];
}

final class SyncIdle extends SyncState {
  const SyncIdle({super.lastSyncedAt});
}

final class SyncRunning extends SyncState {
  const SyncRunning(this.kind, {this.progress = 0, super.lastSyncedAt});

  final SyncKind kind;

  /// From 0 to 1.
  final double progress;

  @override
  List<Object?> get props => [kind, progress, lastSyncedAt];
}

final class SyncSucceeded extends SyncState {
  SyncSucceeded(this.kind, this.report)
    : super(lastSyncedAt: report.finishedAt);

  final SyncKind kind;
  final SyncReport report;

  @override
  List<Object?> get props => [kind, report];
}

final class SyncFailed extends SyncState {
  const SyncFailed(this.kind, this.error, {super.lastSyncedAt});

  final SyncKind kind;

  /// The UI turns it into a sentence.
  final FailureCode error;

  @override
  List<Object?> get props => [kind, error, lastSyncedAt];
}
