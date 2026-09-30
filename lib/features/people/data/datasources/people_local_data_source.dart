import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/debt_balance.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_summary.dart';
import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/person_transaction_type.dart';
import '../../domain/entities/settlement.dart';
import '../models/person_model.dart';
import '../models/person_transaction_model.dart';
import '../models/settlement_model.dart';

abstract interface class PeopleLocalDataSource {
  Future<List<PersonSummary>> getPeople();

  /// Throws a [NotFoundFailure] for a missing or deleted person.
  Future<Person> getPerson(String id);

  /// Open and settled, each with its change log, newest first.
  Future<List<PersonTransaction>> getTransactions(String personId);

  /// Newest first.
  Future<List<Settlement>> getSettlements(String personId);

  Future<PersonTransaction> getTransaction(String id);

  Future<void> insertPerson(Map<String, Object?> row);

  Future<void> updatePerson(String id, Map<String, Object?> row);

  Future<void> deletePerson(String id);

  Future<void> insertTransaction(Map<String, Object?> row);

  /// Writes [row] over an open transaction. When anything actually changes,
  /// the values it had go into its change log under [editId].
  Future<void> updateTransaction(
    String id,
    Map<String, Object?> row, {
    required String editId,
  });

  Future<void> deleteTransaction(String id);

  /// Settles every open transaction with the person under [settlementId].
  /// Returns null when nothing was open.
  Future<Settlement?> settleUp(String personId, {required String settlementId});

  Future<void> linkSettlementToExpense(String settlementId, String expenseId);
}

class PeopleLocalDataSourceImpl implements PeopleLocalDataSource {
  const PeopleLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  static const String _live = 'deleted_at IS NULL';
  static const String _open =
      'person_id = ? AND settled_at IS NULL AND deleted_at IS NULL';

  @override
  Future<List<PersonSummary>> getPeople() => _guard('load people', (db) async {
    // Amounts are summed in whole cents, the way the ledger adds them up.
    // Anything that is not a known "they paid" type counts as the user
    // having paid, as PersonTransactionType.fromStorageKey reads it.
    final rows = await db.rawQuery(
      '''
      SELECT
        p.*,
        COALESCE(SUM(
          CASE WHEN t.id IS NOT NULL AND t.settled_at IS NULL
            THEN CAST(ROUND(t.amount * 100) AS INTEGER)
              * (CASE WHEN t.type = ? THEN -1 ELSE 1 END)
            ELSE 0 END
        ), 0) AS open_cents,
        COALESCE(SUM(
          CASE WHEN t.id IS NOT NULL AND t.settled_at IS NULL THEN 1 ELSE 0 END
        ), 0) AS open_count,
        MAX(t.date) AS last_activity
      FROM people p
      LEFT JOIN person_transactions t
        ON t.person_id = p.id AND t.deleted_at IS NULL
      WHERE p.deleted_at IS NULL
      GROUP BY p.id
      ORDER BY p.name COLLATE NOCASE, p.id
      ''',
      [PersonTransactionType.theyPaidForMe.storageKey],
    );
    return [
      for (final row in rows)
        PersonSummary(
          person: PersonModel.fromMap(row),
          balance: DebtBalance.cents((row['open_cents']! as num).toInt()),
          openCount: (row['open_count']! as num).toInt(),
          lastActivity: row['last_activity'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  (row['last_activity']! as num).toInt(),
                ),
        ),
    ];
  });

  @override
  Future<Person> getPerson(String id) => _guard('load person', (db) async {
    final rows = await db.query(
      'people',
      where: 'id = ? AND $_live',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) throw const NotFoundFailure('person missing');
    return PersonModel.fromMap(rows.first);
  });

  @override
  Future<List<PersonTransaction>> getTransactions(String personId) => _guard(
    'load person transactions',
    (db) async {
      final rows = await db.query(
        'person_transactions',
        where: 'person_id = ? AND $_live',
        whereArgs: [personId],
        orderBy: 'date DESC, created_at DESC, id',
      );
      final editRows = await db.rawQuery(
        '''
          SELECT e.*
          FROM person_transaction_edits e
          INNER JOIN person_transactions t ON t.id = e.transaction_id
          WHERE t.person_id = ? AND t.deleted_at IS NULL
            AND e.deleted_at IS NULL
          ORDER BY e.edited_at, e.id
          ''',
        [personId],
      );
      final edits = <String, List<Map<String, Object?>>>{};
      for (final row in editRows) {
        edits.putIfAbsent(row['transaction_id']! as String, () => []).add(row);
      }
      return [
        for (final row in rows)
          PersonTransactionModel.fromMap(
            row,
            edits: [
              for (final edit in edits[row['id']] ?? const [])
                PersonTransactionModel.editFromMap(edit),
            ],
          ),
      ];
    },
  );

  @override
  Future<List<Settlement>> getSettlements(String personId) =>
      _guard('load settlements', (db) async {
        final rows = await db.query(
          'settlements',
          where: 'person_id = ? AND $_live',
          whereArgs: [personId],
          orderBy: 'settled_at DESC, id',
        );
        return rows.map(SettlementModel.fromMap).toList();
      });

  @override
  Future<PersonTransaction> getTransaction(String id) =>
      _guard('load person transaction', (db) async {
        final rows = await db.query(
          'person_transactions',
          where: 'id = ? AND $_live',
          whereArgs: [id],
          limit: 1,
        );
        if (rows.isEmpty) throw const NotFoundFailure('transaction missing');
        final edits = await db.query(
          'person_transaction_edits',
          where: 'transaction_id = ? AND $_live',
          whereArgs: [id],
          orderBy: 'edited_at, id',
        );
        return PersonTransactionModel.fromMap(
          rows.first,
          edits: edits.map(PersonTransactionModel.editFromMap).toList(),
        );
      });

  @override
  Future<void> insertPerson(Map<String, Object?> row) => _guard(
    'insert person',
    (db) => db.insert('people', AppDatabase.changed(row)),
  );

  @override
  Future<void> updatePerson(String id, Map<String, Object?> row) =>
      _guard('update person', (db) async {
        final count = await db.update(
          'people',
          AppDatabase.changed(row),
          where: 'id = ? AND $_live',
          whereArgs: [id],
        );
        if (count == 0) throw const NotFoundFailure('person missing');
      });

  @override
  Future<void> deletePerson(String id) => _guard('delete person', (db) {
    // Marked rather than removed, so the delete can sync. Everything
    // recorded with the person goes with them.
    final now = AppDatabase.nowMillis();
    final deleted = {'deleted_at': now, 'updated_at': now, 'dirty': 1};
    return db.transaction((txn) async {
      await txn.update(
        'person_transaction_edits',
        deleted,
        where:
            '$_live AND transaction_id IN '
            '(SELECT id FROM person_transactions WHERE person_id = ?)',
        whereArgs: [id],
      );
      for (final table in ['person_transactions', 'settlements']) {
        await txn.update(
          table,
          deleted,
          where: 'person_id = ? AND $_live',
          whereArgs: [id],
        );
      }
      await txn.update(
        'people',
        deleted,
        where: 'id = ? AND $_live',
        whereArgs: [id],
      );
    });
  });

  @override
  Future<void> insertTransaction(Map<String, Object?> row) =>
      _guard('insert person transaction', (db) async {
        // The person must still be there: the foreign key alone would accept
        // one that was deleted.
        final person = await db.query(
          'people',
          columns: ['id'],
          where: 'id = ? AND $_live',
          whereArgs: [row['person_id']],
          limit: 1,
        );
        if (person.isEmpty) throw const NotFoundFailure('person missing');
        await db.insert('person_transactions', AppDatabase.changed(row));
      });

  @override
  Future<void> updateTransaction(
    String id,
    Map<String, Object?> row, {
    required String editId,
  }) => _guard(
    'update person transaction',
    (db) => db.transaction((txn) async {
      final existing = await _openTransaction(txn, id);
      const tracked = ['amount', 'type', 'note', 'date'];
      final changed = tracked.any((column) => existing[column] != row[column]);
      if (!changed) return;

      final now = AppDatabase.nowMillis();
      await txn.insert(
        'person_transaction_edits',
        AppDatabase.changed({
          'id': editId,
          'transaction_id': id,
          for (final column in tracked) column: existing[column],
          'edited_at': now,
        }),
      );
      await txn.update(
        'person_transactions',
        AppDatabase.changed(row),
        where: 'id = ?',
        whereArgs: [id],
      );
    }),
  );

  @override
  Future<void> deleteTransaction(String id) => _guard(
    'delete person transaction',
    (db) => db.transaction((txn) async {
      await _openTransaction(txn, id);
      final now = AppDatabase.nowMillis();
      final deleted = {'deleted_at': now, 'updated_at': now, 'dirty': 1};
      await txn.update(
        'person_transaction_edits',
        deleted,
        where: 'transaction_id = ? AND $_live',
        whereArgs: [id],
      );
      await txn.update(
        'person_transactions',
        deleted,
        where: 'id = ?',
        whereArgs: [id],
      );
    }),
  );

  @override
  Future<Settlement?> settleUp(
    String personId, {
    required String settlementId,
  }) => _guard(
    'settle up',
    (db) => db.transaction((txn) async {
      final person = await txn.query(
        'people',
        columns: ['id'],
        where: 'id = ? AND $_live',
        whereArgs: [personId],
        limit: 1,
      );
      if (person.isEmpty) throw const NotFoundFailure('person missing');

      // Read and cleared inside one transaction, so a transaction added in
      // between cannot end up settled without being counted.
      final open = await txn.query(
        'person_transactions',
        columns: ['amount', 'type'],
        where: _open,
        whereArgs: [personId],
      );
      if (open.isEmpty) return null;

      final balance = DebtBalance.cents(
        open.fold(
          0,
          (sum, row) =>
              sum +
              DebtBalance.toCents((row['amount']! as num).toDouble()) *
                  PersonTransactionType.fromStorageKey(row['type']).sign,
        ),
      );
      final now = AppDatabase.nowMillis();
      await txn.insert(
        'settlements',
        AppDatabase.changed({
          'id': settlementId,
          'person_id': personId,
          'net_amount': balance.amount,
          'settled_at': now,
          'expense_id': null,
          'created_at': now,
        }),
      );
      await txn.update(
        'person_transactions',
        AppDatabase.changed({'settled_at': now, 'settlement_id': settlementId}),
        where: _open,
        whereArgs: [personId],
      );
      return Settlement(
        id: settlementId,
        personId: personId,
        balance: balance,
        settledAt: DateTime.fromMillisecondsSinceEpoch(now),
      );
    }),
  );

  @override
  Future<void> linkSettlementToExpense(String settlementId, String expenseId) =>
      _guard('link settlement', (db) async {
        final count = await db.update(
          'settlements',
          AppDatabase.changed({'expense_id': expenseId}),
          where: 'id = ? AND $_live',
          whereArgs: [settlementId],
        );
        if (count == 0) throw const NotFoundFailure('settlement missing');
      });

  /// The live row of an open transaction. A settled one is part of its
  /// settlement's total and stays as it is.
  static Future<Map<String, Object?>> _openTransaction(
    Transaction txn,
    String id,
  ) async {
    final rows = await txn.query(
      'person_transactions',
      where: 'id = ? AND $_live',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) throw const NotFoundFailure('transaction missing');
    if (rows.first['settled_at'] != null) {
      throw const ValidationFailure(FailureCode.transactionSettled);
    }
    return rows.first;
  }

  Future<T> _guard<T>(
    String action,
    Future<T> Function(Database db) body,
  ) async {
    try {
      return await body(await _appDatabase.database);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('$action: $error');
    }
  }
}
