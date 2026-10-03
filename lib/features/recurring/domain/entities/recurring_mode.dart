/// What happens when a recurring payment falls due.
enum RecurringMode {
  /// The app logs the transaction itself on the due date.
  autoDeduct('auto'),

  /// The app asks the user to confirm the payment before logging it.
  reminder('reminder');

  const RecurringMode(this.storageKey);

  /// How the mode is written to the database, the cloud and backup files.
  final String storageKey;

  /// Anything unknown waits for the user: the app never records spending it
  /// was not clearly told to.
  static RecurringMode fromStorageKey(Object? key) =>
      key == autoDeduct.storageKey ? autoDeduct : reminder;
}
