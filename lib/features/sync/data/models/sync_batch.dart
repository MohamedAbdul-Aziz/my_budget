/// Rows of each synced table, in the phone's SQLite column format.
class SyncBatch {
  const SyncBatch({
    this.categories = const [],
    this.expenses = const [],
    this.settings = const [],
  });

  final List<Map<String, Object?>> categories;
  final List<Map<String, Object?>> expenses;
  final List<Map<String, Object?>> settings;

  int get length => categories.length + expenses.length + settings.length;
}
