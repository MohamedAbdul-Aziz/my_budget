import 'synced_tables.dart';

/// Rows of each user-data table, in the phone's SQLite column format, keyed
/// by table name.
///
/// The one currency for moving data in or out in bulk: the cloud sync and
/// the file backup both read, write and merge records as a [RecordBatch].
class RecordBatch {
  const RecordBatch([this._rows = const {}]);

  final Map<String, List<Map<String, Object?>>> _rows;

  /// [table]'s rows; none when the batch has no entry for it.
  List<Map<String, Object?>> operator [](SyncedTable table) =>
      _rows[table.name] ?? const [];

  List<Map<String, Object?>> get categories => this[SyncedTables.categories];
  List<Map<String, Object?>> get expenses => this[SyncedTables.expenses];
  List<Map<String, Object?>> get settings => this[SyncedTables.settings];
  List<Map<String, Object?>> get recurring => this[SyncedTables.recurring];
  List<Map<String, Object?>> get people => this[SyncedTables.people];
  List<Map<String, Object?>> get settlements => this[SyncedTables.settlements];
  List<Map<String, Object?>> get personTransactions =>
      this[SyncedTables.personTransactions];
  List<Map<String, Object?>> get personTransactionEdits =>
      this[SyncedTables.personTransactionEdits];

  int get length => _rows.values.fold(0, (sum, rows) => sum + rows.length);
}
