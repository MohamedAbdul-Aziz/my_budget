/// Whether money went out or came in.
///
/// Every category is one or the other, and a transaction takes the type of
/// its category, so the two can never disagree.
enum TransactionType {
  expense('expense'),
  income('income');

  const TransactionType(this.storageKey);

  /// How the type is written to the database, the cloud and backup files.
  final String storageKey;

  /// Anything unknown, including a row written before income existed, is an
  /// expense.
  static TransactionType fromStorageKey(Object? key) =>
      key == income.storageKey ? income : expense;
}
