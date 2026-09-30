/// Rows of each user-data table, in the phone's SQLite column format.
///
/// The one currency for moving data in or out in bulk: the cloud sync and
/// the file backup both read, write and merge records as a [RecordBatch].
class RecordBatch {
  const RecordBatch({
    this.categories = const [],
    this.expenses = const [],
    this.settings = const [],
    this.recurring = const [],
  });

  final List<Map<String, Object?>> categories;
  final List<Map<String, Object?>> expenses;
  final List<Map<String, Object?>> settings;

  /// `recurring_expenses` rows.
  final List<Map<String, Object?>> recurring;

  int get length =>
      categories.length + expenses.length + settings.length + recurring.length;
}
