import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/people/domain/entities/debt_balance.dart';
import 'package:my_budget/features/people/domain/entities/people_filter.dart';
import 'package:my_budget/features/people/domain/entities/person.dart';
import 'package:my_budget/features/people/domain/entities/person_summary.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction_type.dart';
import 'package:my_budget/features/people/domain/entities/settlement.dart';
import 'package:my_budget/features/people/domain/usecases/add_person.dart';
import 'package:my_budget/features/people/domain/usecases/add_person_transaction.dart';
import 'package:my_budget/features/people/domain/usecases/delete_person_transaction.dart';
import 'package:my_budget/features/people/domain/usecases/log_settlement_to_budget.dart';
import 'package:my_budget/features/people/domain/usecases/settle_up.dart';
import 'package:my_budget/features/people/domain/usecases/update_person.dart';
import 'package:my_budget/features/people/domain/usecases/update_person_transaction.dart';

import '../presentation/fakes.dart';

const _paid = PersonTransactionType.iPaidForThem;
const _theyPaid = PersonTransactionType.theyPaidForMe;

PersonTransaction _transaction(
  double amount,
  PersonTransactionType type, {
  DateTime? settledAt,
}) => PersonTransaction(
  id: 't',
  personId: 'p',
  amount: amount,
  type: type,
  date: DateTime(2026, 9, 1),
  createdAt: DateTime(2026, 9, 1),
  updatedAt: DateTime(2026, 9, 1),
  settledAt: settledAt,
);

PersonSummary _summary(int cents) => PersonSummary(
  person: Person(
    id: 'p$cents',
    name: 'P',
    colorValue: 0,
    createdAt: DateTime(2026),
  ),
  balance: DebtBalance.cents(cents),
  openCount: 1,
);

void main() {
  group('the net balance', () {
    test('is what I paid for them minus what they paid for me', () {
      final balance = DebtBalance.of([
        _transaction(60, _paid),
        _transaction(25, _theyPaid),
      ]);
      expect(balance.cents, 3500);
      expect(balance.amount, 35);
      expect(balance.direction, DebtDirection.owedToMe);
    });

    test('is negative when I owe them', () {
      final balance = DebtBalance.of([
        _transaction(10, _paid),
        _transaction(12.5, _theyPaid),
      ]);
      expect(balance.cents, -250);
      expect(balance.magnitude, 2.5);
      expect(balance.direction, DebtDirection.iOwe);
    });

    test(
      'is exactly zero when it cancels out, whatever floating point does',
      () {
        final balance = DebtBalance.of([
          _transaction(0.1, _paid),
          _transaction(0.2, _paid),
          _transaction(0.3, _theyPaid),
        ]);
        expect(balance, DebtBalance.zero);
        expect(balance.direction, DebtDirection.settled);
      },
    );
  });

  test('the filters pick people by where the user stands with them', () {
    final owed = _summary(500);
    final owing = _summary(-500);
    final even = _summary(0);
    final everyone = [owed, owing, even];

    List<PersonSummary> pick(PeopleFilter filter) =>
        everyone.where(filter.matches).toList();

    expect(pick(PeopleFilter.all), everyone);
    expect(pick(PeopleFilter.owedToMe), [owed]);
    expect(pick(PeopleFilter.iOwe), [owing]);
    expect(pick(PeopleFilter.settled), [even]);
  });

  test('a person needs a name that fits, and a phone that looks like one', () {
    FailureCode? check(String name, [String? phone]) =>
        AddPerson.validate(name: name, phone: phone)?.code;

    expect(check('  '), FailureCode.personNameRequired);
    expect(check('x' * 41), FailureCode.personNameTooLong);
    expect(check('Sara', 'call me'), FailureCode.phoneInvalid);
    expect(check('Sara', '+20 (100) 123-4567'), isNull);
    expect(check('سارة', '  '), isNull);
  });

  test('the initials are the first letters of the first two words', () {
    Person named(String name) =>
        Person(id: 'p', name: name, colorValue: 0, createdAt: DateTime(2026));
    expect(named('Sara Ahmed Ali').initials, 'SA');
    expect(named('omar').initials, 'o');
    expect(named('سارة أحمد').initials, 'سأ');
  });

  group('use cases', () {
    late FakePeopleRepository people;
    late FakeExpenseRepository expenses;
    late Person sara;

    setUp(() {
      people = FakePeopleRepository();
      expenses = FakeExpenseRepository(FakeCategoryRepository());
      sara = people.seedPerson('Sara');
    });

    test('amounts follow the same rules as everywhere else', () async {
      final add = AddPersonTransaction(people);
      Future<FailureCode?> tryAmount(double amount) async => (await add(
        personId: sara.id,
        amount: amount,
        type: _paid,
        date: DateTime(2026, 9, 1),
      )).failureOrNull?.code;

      expect(await tryAmount(0), FailureCode.amountRequired);
      expect(await tryAmount(2000000000), FailureCode.amountTooLarge);
      expect(await tryAmount(12.5), isNull);
      expect(
        (await add(
          personId: '',
          amount: 5,
          type: _paid,
          date: DateTime(2026, 9, 1),
        )).failureOrNull?.code,
        FailureCode.personRequired,
      );
    });

    test('names and notes are trimmed before they are stored', () async {
      final added = (await AddPersonTransaction(people)(
        personId: sara.id,
        amount: 5,
        type: _paid,
        date: DateTime(2026, 9, 1),
        note: '   ',
      )).dataOrNull!;
      expect(added.note, isNull);

      final renamed = (await UpdatePerson(people)(
        sara,
        name: '  Sara A. ',
        colorValue: 1,
        phone: ' ',
      )).dataOrNull!;
      expect(renamed.name, 'Sara A.');
      expect(renamed.phone, isNull);
      expect(renamed.createdAt, sara.createdAt);
    });

    test('a settled transaction can be neither edited nor deleted', () async {
      final settled = _transaction(5, _paid, settledAt: DateTime(2026, 9, 2));

      final edit = await UpdatePersonTransaction(people)(
        settled,
        amount: 6,
        type: _paid,
        date: DateTime(2026, 9, 1),
      );
      final delete = await DeletePersonTransaction(people)(settled);

      expect(edit.failureOrNull?.code, FailureCode.transactionSettled);
      expect(delete.failureOrNull?.code, FailureCode.transactionSettled);
    });

    test('settling with nothing open is refused', () async {
      final result = await SettleUp(people)(sara.id);
      expect(result.failureOrNull?.code, FailureCode.nothingToSettle);
    });

    test(
      'money received to settle is logged as income in Other income',
      () async {
        people.seedTransaction(sara, 30, _paid);
        final settlement = (await SettleUp(people)(sara.id)).dataOrNull!;
        final log = LogSettlementToBudget(
          peopleRepository: people,
          expenseRepository: expenses,
        );

        final expense = (await log(
          settlement,
          description: 'Settlement with Sara',
        )).dataOrNull!;

        expect(expense.amount, 30);
        expect(expense.category.id, ExpenseCategory.incomeFallbackId);
        expect(expense.type, TransactionType.income);
        expect(people.settlements.single.expenseId, expense.id);
      },
    );

    test('money paid to settle is logged as an expense in Other', () async {
      people.seedTransaction(sara, 12, _theyPaid);
      final settlement = (await SettleUp(people)(sara.id)).dataOrNull!;

      final expense = (await LogSettlementToBudget(
        peopleRepository: people,
        expenseRepository: expenses,
      )(settlement, description: 'x')).dataOrNull!;

      expect(expense.category.id, ExpenseCategory.fallbackId);
      expect(expense.amount, 12);
    });

    test('a settlement where nothing changed hands, or already logged, is '
        'not logged', () async {
      final log = LogSettlementToBudget(
        peopleRepository: people,
        expenseRepository: expenses,
      );
      final even = Settlement(
        id: 's1',
        personId: sara.id,
        balance: DebtBalance.zero,
        settledAt: DateTime(2026, 9, 1),
      );
      final logged = Settlement(
        id: 's2',
        personId: sara.id,
        balance: const DebtBalance.cents(500),
        settledAt: DateTime(2026, 9, 1),
        expenseId: 'exp_1',
      );

      expect(
        (await log(even, description: 'x')).failureOrNull?.code,
        FailureCode.nothingToSettle,
      );
      expect(
        (await log(logged, description: 'x')).failureOrNull?.code,
        FailureCode.settlementAlreadyLogged,
      );
      expect(expenses.expenses, isEmpty);
    });
  });
}
