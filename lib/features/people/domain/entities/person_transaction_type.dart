/// Which way the money went between the user and a person.
enum PersonTransactionType {
  /// The user paid for the person, so the person owes the user more.
  iPaidForThem('i_paid_for_them', 1),

  /// The person paid for the user, so the user owes the person more.
  theyPaidForMe('they_paid_for_me', -1);

  const PersonTransactionType(this.storageKey, this.sign);

  /// How the type is written to the database, the cloud and backup files.
  final String storageKey;

  /// +1 when the transaction adds to what the person owes the user, -1 when
  /// it adds to what the user owes them.
  final int sign;

  static PersonTransactionType? tryParse(Object? key) {
    for (final type in values) {
      if (type.storageKey == key) return type;
    }
    return null;
  }

  /// Anything unknown is read as the user having paid, which never makes
  /// the user owe money they did not borrow.
  static PersonTransactionType fromStorageKey(Object? key) =>
      tryParse(key) ?? iPaidForThem;
}
