/// How often a recurring payment falls due.
enum RecurrenceFrequency {
  weekly('weekly'),
  monthly('monthly'),
  yearly('yearly');

  const RecurrenceFrequency(this.storageKey);

  /// How the frequency is written to the database, the cloud and backup
  /// files.
  final String storageKey;

  /// Anything unknown is monthly, by far the most common schedule.
  static RecurrenceFrequency fromStorageKey(Object? key) => values.firstWhere(
    (frequency) => frequency.storageKey == key,
    orElse: () => monthly,
  );
}
