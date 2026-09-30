import 'package:equatable/equatable.dart';

/// What a backup file holds, read and checked before anything is imported,
/// so the user knows what they are confirming.
class BackupPreview extends Equatable {
  const BackupPreview({
    required this.path,
    required this.expenses,
    required this.categories,
    this.people = 0,
    this.exportedAt,
  });

  final String path;

  /// Records that are not deleted.
  final int expenses;
  final int categories;

  /// None in a backup from before people existed.
  final int people;

  /// When the backup was made; null if the file does not say.
  final DateTime? exportedAt;

  @override
  List<Object?> get props => [path, expenses, categories, people, exportedAt];
}
