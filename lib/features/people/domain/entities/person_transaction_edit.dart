import 'package:equatable/equatable.dart';

import 'person_transaction_type.dart';

/// One entry in a transaction's change log: the values it had just before
/// an edit, and when that edit was made. The current values live on the
/// transaction itself.
class PersonTransactionEdit extends Equatable {
  const PersonTransactionEdit({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.date,
    required this.editedAt,
    this.note,
  });

  final String id;
  final String transactionId;
  final double amount;
  final PersonTransactionType type;
  final String? note;
  final DateTime date;
  final DateTime editedAt;

  @override
  List<Object?> get props => [
    id,
    transactionId,
    amount,
    type,
    note,
    date,
    editedAt,
  ];
}
