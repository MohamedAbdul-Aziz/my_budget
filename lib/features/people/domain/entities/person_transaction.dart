import 'package:equatable/equatable.dart';

import 'debt_balance.dart';
import 'person_transaction_edit.dart';
import 'person_transaction_type.dart';

/// Money that changed hands between the user and one person: the user paid
/// for them, or they paid for the user.
///
/// Open until a settlement clears it. A settled transaction is part of that
/// settlement's total, so it can no longer be edited or deleted.
class PersonTransaction extends Equatable {
  const PersonTransaction({
    required this.id,
    required this.personId,
    required this.amount,
    required this.type,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.settledAt,
    this.settlementId,
    this.edits = const [],
  });

  final String id;
  final String personId;

  /// Always positive; [type] says which way it went.
  final double amount;
  final PersonTransactionType type;
  final String? note;

  /// When the money changed hands, as the user entered it.
  final DateTime date;

  // The audit trail: when the record was made, last changed, and settled.
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? settledAt;

  /// The settlement that cleared this transaction.
  final String? settlementId;

  /// The values before each edit, oldest first.
  final List<PersonTransactionEdit> edits;

  bool get isSettled => settledAt != null;

  bool get wasEdited => edits.isNotEmpty;

  /// When it was last edited, which is not [updatedAt]: settling a
  /// transaction or syncing it also changes that.
  DateTime? get lastEditedAt => edits.isEmpty ? null : edits.last.editedAt;

  /// What this adds to the balance, in cents: positive when the person owes
  /// the user more because of it.
  int get signedCents => DebtBalance.toCents(amount) * type.sign;

  @override
  List<Object?> get props => [
    id,
    personId,
    amount,
    type,
    note,
    date,
    createdAt,
    updatedAt,
    settledAt,
    settlementId,
    edits,
  ];
}
