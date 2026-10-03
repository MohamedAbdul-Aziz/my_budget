import 'package:equatable/equatable.dart';

import 'person_transaction.dart';

/// Where the user stands with a person.
enum DebtDirection {
  /// The balance is positive: the person owes the user.
  owedToMe,

  /// The balance is negative: the user owes the person.
  iOwe,

  /// Nothing is owed either way.
  settled,
}

/// A net balance with one person: what the user paid for them minus what
/// they paid for the user, over the transactions not yet settled.
///
/// Held in whole cents, so adding up many amounts never leaves a stray
/// fraction that would make a settled balance look open.
class DebtBalance extends Equatable {
  const DebtBalance.cents(this.cents);

  static const DebtBalance zero = DebtBalance.cents(0);

  factory DebtBalance.of(Iterable<PersonTransaction> transactions) =>
      DebtBalance.cents(transactions.fold(0, (sum, t) => sum + t.signedCents));

  factory DebtBalance.fromAmount(double amount) =>
      DebtBalance.cents(toCents(amount));

  static int toCents(double amount) => (amount * 100).round();

  /// Positive when the person owes the user, negative when the user owes the
  /// person.
  final int cents;

  double get amount => cents / 100;

  /// The amount without its sign: what has to change hands to settle.
  double get magnitude => cents.abs() / 100;

  DebtDirection get direction => switch (cents) {
    > 0 => DebtDirection.owedToMe,
    < 0 => DebtDirection.iOwe,
    _ => DebtDirection.settled,
  };

  bool get isSettled => cents == 0;

  DebtBalance operator +(DebtBalance other) =>
      DebtBalance.cents(cents + other.cents);

  @override
  List<Object?> get props => [cents];
}
