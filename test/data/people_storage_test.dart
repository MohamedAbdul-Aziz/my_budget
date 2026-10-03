import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:my_budget/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/people/data/datasources/people_local_data_source.dart';
import 'package:my_budget/features/people/data/repositories/people_repository_impl.dart';
import 'package:my_budget/features/people/domain/entities/debt_balance.dart';
import 'package:my_budget/features/people/domain/entities/person.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction_type.dart';
import 'package:my_budget/features/people/domain/usecases/log_settlement_to_budget.dart';

/// People and debts against the real SQLite schema.
void main() {
  late AppDatabase database;
  late PeopleRepositoryImpl people;
  late ExpenseRepositoryImpl expenses;

  setUp(() {
    database = AppDatabase(inMemory: true);
    people = PeopleRepositoryImpl(PeopleLocalDataSourceImpl(database));
    expenses = ExpenseRepositoryImpl(ExpenseLocalDataSourceImpl(database));
  });

  tearDown(() => database.close());

  Future<Person> addPerson(String name) async =>
      (await people.addPerson(name: name, colorValue: 0xFF1E88E5)).dataOrNull!;

  Future<PersonTransaction> add(
    Person person,
    double amount,
    PersonTransactionType type, {
    String? note,
  }) async => (await people.addTransaction(
    personId: person.id,
    amount: amount,
    type: type,
    date: DateTime(2026, 9, 10),
    note: note,
  )).dataOrNull!;

  const paid = PersonTransactionType.iPaidForThem;
  const theyPaid = PersonTransactionType.theyPaidForMe;

  test('the balance is what I paid for them minus what they paid for me, '
      'added up in whole cents', () async {
    final sara = await addPerson('Sara');
    final omar = await addPerson('Omar');
    await addPerson('Zeina');
    // 0.1 + 0.2 is not 0.3 in floating point; in cents it is.
    await add(sara, 0.1, paid);
    await add(sara, 0.2, paid);
    await add(sara, 0.3, theyPaid);
    await add(omar, 40, theyPaid);
    await add(omar, 15.5, paid);

    final list = (await people.getPeople()).dataOrNull!;

    expect(list.map((p) => p.person.name), ['Omar', 'Sara', 'Zeina']);
    final bySara = list.firstWhere((p) => p.person.id == sara.id);
    expect(bySara.balance, DebtBalance.zero);
    expect(bySara.balance.direction, DebtDirection.settled);
    expect(bySara.openCount, 3);
    final byOmar = list.firstWhere((p) => p.person.id == omar.id);
    expect(byOmar.balance.cents, -2450);
    expect(byOmar.balance.direction, DebtDirection.iOwe);
    final zeina = list.firstWhere((p) => p.person.name == 'Zeina');
    expect(zeina.balance.direction, DebtDirection.settled);
    expect(zeina.lastActivity, isNull);
  });

  test('an edit keeps the values it replaced in the change log', () async {
    final sara = await addPerson('Sara');
    final lunch = await add(sara, 20, paid, note: 'Lunch');

    final edited = (await people.updateTransaction(
      id: lunch.id,
      amount: 25,
      type: paid,
      date: DateTime(2026, 9, 11),
      note: 'Lunch and coffee',
    )).dataOrNull!;

    expect(edited.amount, 25);
    expect(edited.createdAt, lunch.createdAt);
    expect(edited.updatedAt.isBefore(lunch.updatedAt), isFalse);
    final log = edited.edits.single;
    expect(log.amount, 20);
    expect(log.note, 'Lunch');
    expect(log.date, DateTime(2026, 9, 10));
    expect(edited.lastEditedAt, log.editedAt);

    // Saving without changing anything adds nothing to the log.
    final unchanged = (await people.updateTransaction(
      id: lunch.id,
      amount: 25,
      type: paid,
      date: DateTime(2026, 9, 11),
      note: 'Lunch and coffee',
    )).dataOrNull!;
    expect(unchanged.edits, hasLength(1));
  });

  test('settling clears every open transaction under one settlement, and '
      'the settled ones are locked', () async {
    final sara = await addPerson('Sara');
    final dinner = await add(sara, 60, paid);
    await add(sara, 25, theyPaid);

    final settlement = (await people.settleUp(sara.id)).dataOrNull!;
    expect(settlement.balance.cents, 3500);
    expect(settlement.budgetType, TransactionType.income);

    final ledger = (await people.getLedger(sara.id)).dataOrNull!;
    expect(ledger.open, isEmpty);
    expect(ledger.balance, DebtBalance.zero);
    final group = ledger.history.single;
    expect(group.settlement.id, settlement.id);
    expect(group.transactions, hasLength(2));
    expect(
      group.transactions.every(
        (t) => t.settledAt != null && t.settlementId == settlement.id,
      ),
      isTrue,
    );

    final edit = await people.updateTransaction(
      id: dinner.id,
      amount: 1,
      type: paid,
      date: DateTime(2026, 9, 10),
    );
    expect(edit.failureOrNull?.code, FailureCode.transactionSettled);
    final delete = await people.deleteTransaction(dinner.id);
    expect(delete.failureOrNull?.code, FailureCode.transactionSettled);

    // Nothing open is nothing to settle.
    expect((await people.settleUp(sara.id)).dataOrNull, isNull);

    // A new transaction starts a fresh balance next to the history.
    await add(sara, 10, theyPaid);
    final after = (await people.getLedger(sara.id)).dataOrNull!;
    expect(after.balance.cents, -1000);
    expect(after.history, hasLength(1));
  });

  test('a settlement logged in the budget is income or an expense in the '
      'fallback category, and remembers it', () async {
    final sara = await addPerson('Sara');
    await add(sara, 30, theyPaid);
    final settlement = (await people.settleUp(sara.id)).dataOrNull!;
    final log = LogSettlementToBudget(
      peopleRepository: people,
      expenseRepository: expenses,
    );

    final expense = (await log(
      settlement,
      description: 'Settlement with Sara',
    )).dataOrNull!;

    expect(expense.amount, 30);
    expect(expense.category.id, ExpenseCategory.fallbackId);
    expect(expense.description, 'Settlement with Sara');
    final month = (await expenses.getTransactionsForMonth(
      Month.fromDate(settlement.settledAt),
    )).dataOrNull!;
    expect(month.single.id, expense.id);

    final ledger = (await people.getLedger(sara.id)).dataOrNull!;
    expect(ledger.history.single.settlement.expenseId, expense.id);
  });

  test('deleting a transaction takes its change log along', () async {
    final sara = await addPerson('Sara');
    final lunch = await add(sara, 20, paid);
    await people.updateTransaction(
      id: lunch.id,
      amount: 22,
      type: paid,
      date: DateTime(2026, 9, 10),
    );

    await people.deleteTransaction(lunch.id);

    final db = await database.database;
    final edits = await db.query('person_transaction_edits');
    expect(edits.single['deleted_at'], isNotNull);
    expect(edits.single['dirty'], 1);
    expect((await people.getLedger(sara.id)).dataOrNull!.isEmpty, isTrue);
  });

  test('deleting a person takes everything recorded with them, marked for '
      'the next backup', () async {
    final sara = await addPerson('Sara');
    final lunch = await add(sara, 20, paid);
    await people.updateTransaction(
      id: lunch.id,
      amount: 22,
      type: paid,
      date: DateTime(2026, 9, 10),
    );
    await add(sara, 5, theyPaid);
    await people.settleUp(sara.id);

    await people.deletePerson(sara.id);

    expect((await people.getPeople()).dataOrNull, isEmpty);
    expect(
      (await people.getLedger(sara.id)).failureOrNull?.code,
      FailureCode.notFound,
    );
    final db = await database.database;
    for (final table in AppDatabase.peopleTables) {
      final rows = await db.query(table);
      expect(rows, isNotEmpty, reason: table);
      expect(
        rows.every((row) => row['deleted_at'] != null && row['dirty'] == 1),
        isTrue,
        reason: table,
      );
    }
  });

  test('a transaction cannot be added for a deleted person', () async {
    final sara = await addPerson('Sara');
    await people.deletePerson(sara.id);

    final result = await people.addTransaction(
      personId: sara.id,
      amount: 5,
      type: paid,
      date: DateTime(2026, 9, 10),
    );

    expect(result.failureOrNull?.code, FailureCode.notFound);
  });
}
