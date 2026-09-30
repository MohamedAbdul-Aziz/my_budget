import '../../../people/domain/entities/debt_balance.dart';
import '../../../people/domain/entities/person_transaction_type.dart';
import '../models/export_texts.dart';

/// The people and debts rows of an export, read the way the app reads them:
/// deleted rows skipped, balances added up in whole cents over the open
/// transactions only.
///
/// Pure Dart, so it can run on a background isolate.
class DebtRows {
  DebtRows({
    required List<Map<String, Object?>> people,
    required List<Map<String, Object?>> settlements,
    required List<Map<String, Object?>> transactions,
    required List<Map<String, Object?>> edits,
  }) : people = _live(people)
         ..sort(
           (a, b) => '${a['name']}'.toLowerCase().compareTo(
             '${b['name']}'.toLowerCase(),
           ),
         ),
       settlements = _live(settlements)
         ..sort(
           (a, b) => _int(b['settled_at']).compareTo(_int(a['settled_at'])),
         ),
       transactions = _live(transactions)
         ..sort((a, b) {
           final byDate = _int(b['date']).compareTo(_int(a['date']));
           return byDate != 0
               ? byDate
               : _int(b['created_at']).compareTo(_int(a['created_at']));
         }) {
    for (final edit in _live(edits)) {
      final id = edit['transaction_id']! as String;
      final editedAt = _int(edit['edited_at']);
      final (count, last) = _edits[id] ?? (0, 0);
      _edits[id] = (count + 1, editedAt > last ? editedAt : last);
    }
    for (final row in this.transactions) {
      if (row['settled_at'] != null) continue;
      final id = row['person_id']! as String;
      _balances[id] = (_balances[id] ?? 0) + signedCents(row);
    }
  }

  /// Alphabetical.
  final List<Map<String, Object?>> people;

  /// Newest first.
  final List<Map<String, Object?>> settlements;

  /// Newest first.
  final List<Map<String, Object?>> transactions;

  final Map<String, (int, int)> _edits = {};
  final Map<String, int> _balances = {};

  bool get isEmpty => people.isEmpty;

  String personName(Object? id) {
    for (final person in people) {
      if (person['id'] == id) return '${person['name']}';
    }
    return '$id';
  }

  DebtBalance balanceOf(Object? personId) =>
      DebtBalance.cents(_balances[personId] ?? 0);

  /// What everyone owes the user, and what the user owes everyone.
  (double, double) get totals {
    var owed = 0;
    var owing = 0;
    for (final cents in _balances.values) {
      if (cents > 0) owed += cents;
      if (cents < 0) owing -= cents;
    }
    return (owed / 100, owing / 100);
  }

  /// How many times the transaction was edited, and when it last was.
  (int, DateTime?) editsOf(Object? transactionId) {
    final (count, last) = _edits[transactionId] ?? (0, 0);
    return (
      count,
      count == 0 ? null : DateTime.fromMillisecondsSinceEpoch(last),
    );
  }

  static int signedCents(Map<String, Object?> row) =>
      DebtBalance.toCents((row['amount']! as num).toDouble()) *
      PersonTransactionType.fromStorageKey(row['type']).sign;

  static String typeLabel(Map<String, Object?> row, ExportTexts texts) =>
      switch (PersonTransactionType.fromStorageKey(row['type'])) {
        PersonTransactionType.iPaidForThem => texts.iPaidForThem,
        PersonTransactionType.theyPaidForMe => texts.theyPaidForMe,
      };

  static String standing(DebtBalance balance, ExportTexts texts) =>
      switch (balance.direction) {
        DebtDirection.owedToMe => texts.owesYou,
        DebtDirection.iOwe => texts.youOwe,
        DebtDirection.settled => texts.settledUp,
      };

  /// Which way a settlement's money went.
  static String settlementDirection(
    Map<String, Object?> row,
    ExportTexts texts,
  ) {
    final net = (row['net_amount']! as num).toDouble();
    return net > 0
        ? texts.theyPaidYou
        : net < 0
        ? texts.youPaidThem
        : texts.settledUp;
  }

  /// How many transactions [settlementId] cleared.
  int clearedBy(Object? settlementId) =>
      transactions.where((row) => row['settlement_id'] == settlementId).length;

  static DateTime time(Object? millis) =>
      DateTime.fromMillisecondsSinceEpoch(_int(millis));

  static List<Map<String, Object?>> _live(List<Map<String, Object?>> rows) => [
    for (final row in rows)
      if (row['deleted_at'] == null) row,
  ];

  static int _int(Object? value) => (value! as num).toInt();
}
