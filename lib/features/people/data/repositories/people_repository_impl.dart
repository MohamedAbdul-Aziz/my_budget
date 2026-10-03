import 'dart:math';

import '../../../../core/error/api_result.dart';
import '../../domain/entities/debt_balance.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_ledger.dart';
import '../../domain/entities/person_summary.dart';
import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/person_transaction_type.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/repositories/people_repository.dart';
import '../datasources/people_local_data_source.dart';
import '../models/person_model.dart';
import '../models/person_transaction_model.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl(this._localDataSource);

  final PeopleLocalDataSource _localDataSource;
  final Random _random = Random();

  @override
  Future<ApiResult<List<PersonSummary>>> getPeople() =>
      ApiResult.guard(_localDataSource.getPeople);

  @override
  Future<ApiResult<PersonLedger>> getLedger(String personId) =>
      ApiResult.guard(() async {
        final person = await _localDataSource.getPerson(personId);
        final transactions = await _localDataSource.getTransactions(personId);
        final settlements = await _localDataSource.getSettlements(personId);
        return _ledger(person, transactions, settlements);
      });

  @override
  Future<ApiResult<Person>> addPerson({
    required String name,
    required int colorValue,
    String? phone,
  }) => ApiResult.guard(() async {
    final person = Person(
      id: _newId('per'),
      name: name,
      phone: phone,
      colorValue: colorValue,
      createdAt: DateTime.now(),
    );
    await _localDataSource.insertPerson(PersonModel.toRow(person));
    return person;
  });

  @override
  Future<ApiResult<Person>> updatePerson(Person person) => ApiResult.guard(
    () async {
      await _localDataSource.updatePerson(person.id, PersonModel.toRow(person));
      return person;
    },
  );

  @override
  Future<ApiResult<void>> deletePerson(String personId) =>
      ApiResult.guard(() => _localDataSource.deletePerson(personId));

  @override
  Future<ApiResult<PersonTransaction>> addTransaction({
    required String personId,
    required double amount,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) => ApiResult.guard(() async {
    final id = _newId('ptx');
    await _localDataSource.insertTransaction({
      'id': id,
      'person_id': personId,
      ...PersonTransactionModel.toRow(
        amount: amount,
        type: type,
        date: date,
        note: note,
      ),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
    return _localDataSource.getTransaction(id);
  });

  @override
  Future<ApiResult<PersonTransaction>> updateTransaction({
    required String id,
    required double amount,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) => ApiResult.guard(() async {
    await _localDataSource.updateTransaction(
      id,
      PersonTransactionModel.toRow(
        amount: amount,
        type: type,
        date: date,
        note: note,
      ),
      editId: _newId('pte'),
    );
    return _localDataSource.getTransaction(id);
  });

  @override
  Future<ApiResult<void>> deleteTransaction(String id) =>
      ApiResult.guard(() => _localDataSource.deleteTransaction(id));

  @override
  Future<ApiResult<Settlement?>> settleUp(String personId) => ApiResult.guard(
    () => _localDataSource.settleUp(personId, settlementId: _newId('set')),
  );

  @override
  Future<ApiResult<void>> linkSettlementToExpense({
    required String settlementId,
    required String expenseId,
  }) => ApiResult.guard(
    () => _localDataSource.linkSettlementToExpense(settlementId, expenseId),
  );

  /// Sorts the transactions into the open balance and the settled history,
  /// grouped under the settlement that cleared them.
  static PersonLedger _ledger(
    Person person,
    List<PersonTransaction> transactions,
    List<Settlement> settlements,
  ) {
    final open = <PersonTransaction>[];
    final cleared = <String, List<PersonTransaction>>{};
    for (final transaction in transactions) {
      if (transaction.isSettled) {
        cleared
            .putIfAbsent(transaction.settlementId ?? '', () => [])
            .add(transaction);
      } else {
        open.add(transaction);
      }
    }

    final history = [
      for (final settlement in settlements)
        SettledGroup(
          settlement: settlement,
          transactions: cleared.remove(settlement.id) ?? const [],
        ),
      // Settled transactions whose settlement record never arrived (only a
      // damaged copy could do that) still show, under what they add up to.
      for (final MapEntry(key: id, value: items) in cleared.entries)
        SettledGroup(
          settlement: Settlement(
            id: id,
            personId: person.id,
            balance: DebtBalance.of(items),
            settledAt: items
                .map((t) => t.settledAt!)
                .reduce((a, b) => a.isAfter(b) ? a : b),
          ),
          transactions: items,
        ),
    ]..sort((a, b) => b.settlement.settledAt.compareTo(a.settlement.settledAt));

    return PersonLedger(person: person, open: open, history: history);
  }

  String _newId(String prefix) =>
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}_'
      '${_random.nextInt(0xFFFF)}';
}
