import 'package:equatable/equatable.dart';

/// What a finished backup or restore did.
class SyncReport extends Equatable {
  const SyncReport({required this.changes, required this.finishedAt});

  /// Records uploaded by a backup, or applied to this phone by a restore.
  final int changes;

  final DateTime finishedAt;

  @override
  List<Object?> get props => [changes, finishedAt];
}
