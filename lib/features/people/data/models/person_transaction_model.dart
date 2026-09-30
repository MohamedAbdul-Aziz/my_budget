import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/person_transaction_edit.dart';
import '../../domain/entities/person_transaction_type.dart';

/// Maps `person_transactions` and `person_transaction_edits` rows to the
/// domain entities and back.
abstract final class PersonTransactionModel {
  static PersonTransaction fromMap(
    Map<String, Object?> map, {
    List<PersonTransactionEdit> edits = const [],
  }) => PersonTransaction(
    id: map['id']! as String,
    personId: map['person_id']! as String,
    amount: (map['amount']! as num).toDouble(),
    type: PersonTransactionType.fromStorageKey(map['type']),
    note: map['note'] as String?,
    date: _time(map['date'])!,
    createdAt: _time(map['created_at'])!,
    updatedAt: _time(map['updated_at'])!,
    settledAt: _time(map['settled_at']),
    settlementId: map['settlement_id'] as String?,
    edits: edits,
  );

  /// The fields the user controls. Settling and the sync columns are
  /// written separately.
  static Map<String, Object?> toRow({
    required double amount,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) => {
    'amount': amount,
    'type': type.storageKey,
    'note': note,
    'date': date.millisecondsSinceEpoch,
  };

  static PersonTransactionEdit editFromMap(Map<String, Object?> map) =>
      PersonTransactionEdit(
        id: map['id']! as String,
        transactionId: map['transaction_id']! as String,
        amount: (map['amount']! as num).toDouble(),
        type: PersonTransactionType.fromStorageKey(map['type']),
        note: map['note'] as String?,
        date: _time(map['date'])!,
        editedAt: _time(map['edited_at'])!,
      );

  static DateTime? _time(Object? millis) => millis == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch((millis as num).toInt());
}
