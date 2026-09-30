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
    this.people = const [],
    this.settlements = const [],
    this.personTransactions = const [],
    this.personTransactionEdits = const [],
  });

  final List<Map<String, Object?>> categories;
  final List<Map<String, Object?>> expenses;
  final List<Map<String, Object?>> settings;

  /// `recurring_expenses` rows.
  final List<Map<String, Object?>> recurring;

  // People and debts, in the order the tables depend on each other.
  final List<Map<String, Object?>> people;
  final List<Map<String, Object?>> settlements;
  final List<Map<String, Object?>> personTransactions;
  final List<Map<String, Object?>> personTransactionEdits;

  /// The people and debts rows by table name, parents first.
  Map<String, List<Map<String, Object?>>> get peopleTables => {
    'people': people,
    'settlements': settlements,
    'person_transactions': personTransactions,
    'person_transaction_edits': personTransactionEdits,
  };

  int get length =>
      categories.length +
      expenses.length +
      settings.length +
      recurring.length +
      people.length +
      settlements.length +
      personTransactions.length +
      personTransactionEdits.length;
}
