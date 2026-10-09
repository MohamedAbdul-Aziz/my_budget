import '../../../../core/database/record_batch.dart';
import '../../../../core/database/synced_tables.dart';
import '../../../categories/domain/entities/category_name.dart';

/// Folds imported categories into ones that already have the same name.
///
/// An imported file (another phone's backup, or an AI chat's answer) can
/// bring a category the user already has under a different id: "Coffee"
/// made twice, or an AI's "Food" next to the built-in one. Rather than
/// adding a second "Coffee", its transactions and recurring payments are
/// moved to the category already here, and the duplicate is dropped. The
/// same happens to repeats within the file itself.
///
/// Only the name and the type count, compared by [CategoryName.key]: the
/// same name for spending and for income stays two categories. A category
/// with the same id as one here is the same category and is left alone.
abstract final class CategoryMerge {
  /// [incoming] with its duplicate categories folded into [existing] (the
  /// phone's own rows; empty when the import replaces everything) or into
  /// an earlier category of the same file. [namesOf] gives every name a row
  /// goes by, such as a built-in category's name in each language.
  static RecordBatch apply(
    RecordBatch incoming, {
    required List<Map<String, Object?>> existing,
    required Set<String> Function(Map<String, Object?> row) namesOf,
  }) {
    final byName = <String, String>{};
    void remember(Map<String, Object?> row) {
      for (final name in namesOf(row)) {
        byName.putIfAbsent(_key(row, name), () => row['id']! as String);
      }
    }

    final knownIds = <String>{};
    for (final row in existing) {
      knownIds.add(row['id']! as String);
      if (row['deleted_at'] == null) remember(row);
    }

    final moved = <String, String>{};
    final categories = <Map<String, Object?>>[];
    for (final row in incoming.categories) {
      final id = row['id']! as String;
      if (row['deleted_at'] != null || knownIds.contains(id)) {
        categories.add(row);
        continue;
      }
      final match = namesOf(
        row,
      ).map((name) => byName[_key(row, name)]).whereType<String>().firstOrNull;
      if (match != null && match != id) {
        moved[id] = match;
      } else {
        categories.add(row);
        remember(row);
      }
    }
    if (moved.isEmpty) return incoming;

    return RecordBatch({
      for (final table in SyncedTables.all)
        table.name: switch (table.categoryColumn) {
          _ when table == SyncedTables.categories => categories,
          final column? => [
            for (final row in incoming[table])
              if (moved[row[column]] case final to?)
                {...row, column: to}
              else
                row,
          ],
          null => incoming[table],
        },
    });
  }

  static String _key(Map<String, Object?> row, String name) =>
      '${row['type'] ?? 'expense'}|${CategoryName.key(name)}';
}
