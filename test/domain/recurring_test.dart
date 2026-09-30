import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_draft.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_expense.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_overview.dart';
import 'package:my_budget/features/recurring/domain/usecases/get_recurring_overview.dart';
import 'package:my_budget/features/recurring/domain/usecases/log_due_recurring.dart';
import 'package:my_budget/features/recurring/domain/usecases/mark_recurring_paid.dart';
import 'package:my_budget/features/recurring/domain/usecases/save_recurring_expense.dart';

import '../presentation/fakes.dart';

const _bills = ExpenseCategory(
  id: 'cat_bills',
  name: 'Bills',
  iconName: 'receipt_long',
  colorValue: 0xFF6D4C41,
  isDefault: true,
);

RecurringExpense _recurring({
  RecurrenceFrequency frequency = RecurrenceFrequency.monthly,
  int dueDay = 15,
  int? dueMonth,
  RecurringMode mode = RecurringMode.reminder,
  DateTime? startsOn,
  DateTime? paidThrough,
  double amount = 100,
}) => RecurringExpense(
  id: 'rec_1',
  title: 'Rent',
  amount: amount,
  category: _bills,
  frequency: frequency,
  dueDay: dueDay,
  dueMonth: dueMonth,
  mode: mode,
  startsOn: startsOn ?? DateTime(2026, 9, 1),
  paidThrough: paidThrough,
  createdAt: DateTime(2026, 9, 1),
);

RecurringCommitment _on(RecurringExpense recurring, DateTime today) =>
    GetRecurringOverview.statusOf(recurring, today: today);

void main() {
  group('due dates', () {
    test('a monthly day a month lacks falls on its last day', () {
      final end = _recurring(dueDay: 31, startsOn: DateTime(2026, 1, 1));
      expect(end.unsettledThrough(DateTime(2026, 5, 1)), [
        DateTime(2026, 1, 31),
        DateTime(2026, 2, 28),
        DateTime(2026, 3, 31),
        DateTime(2026, 4, 30),
      ]);
    });

    test('a weekly payment falls on its weekday', () {
      // 30 September 2026 is a Wednesday.
      final friday = _recurring(
        frequency: RecurrenceFrequency.weekly,
        dueDay: DateTime.friday,
      );
      expect(friday.dueOnOrAfter(DateTime(2026, 9, 30)), DateTime(2026, 10, 2));
      expect(friday.dueOnOrAfter(DateTime(2026, 10, 2)), DateTime(2026, 10, 2));
      expect(friday.dueOnOrAfter(DateTime(2026, 10, 3)), DateTime(2026, 10, 9));
    });

    test('29 February falls on the 28th in years without one', () {
      final leap = _recurring(
        frequency: RecurrenceFrequency.yearly,
        dueDay: 29,
        dueMonth: 2,
      );
      expect(leap.dueOnOrAfter(DateTime(2026, 9, 1)), DateTime(2027, 2, 28));
      expect(leap.dueOnOrAfter(DateTime(2027, 3, 1)), DateTime(2028, 2, 29));
    });

    test('nothing before the start date is ever due', () {
      final late = _recurring(dueDay: 5, startsOn: DateTime(2026, 9, 20));
      expect(late.nextDue, DateTime(2026, 10, 5));
    });

    test('the next payment follows the last one settled', () {
      final paid = _recurring(paidThrough: DateTime(2026, 9, 15));
      expect(paid.nextDue, DateTime(2026, 10, 15));
      expect(paid.isSettled(DateTime(2026, 9, 15)), isTrue);
      expect(paid.isSettled(DateTime(2026, 10, 15)), isFalse);
    });
  });

  group('status this month', () {
    test('upcoming before the due date, and payable now', () {
      final item = _on(_recurring(), DateTime(2026, 9, 10));
      expect(item.status, RecurringStatus.upcoming);
      expect(item.nextDue, DateTime(2026, 9, 15));
      expect(item.isPayableNow, isTrue);
      expect(item.needsConfirmation, isFalse);
    });

    test('a reminder due today asks to be confirmed', () {
      final item = _on(_recurring(), DateTime(2026, 9, 15, 18, 30));
      expect(item.status, RecurringStatus.upcoming);
      expect(item.isDueToday, isTrue);
      expect(item.needsConfirmation, isTrue);
    });

    test('overdue the day after, counting every missed payment', () {
      expect(
        _on(_recurring(), DateTime(2026, 9, 16)).status,
        RecurringStatus.overdue,
      );
      final twice = _on(_recurring(), DateTime(2026, 10, 20));
      expect(twice.status, RecurringStatus.overdue);
      expect(twice.overdueCount, 2);
      // The oldest one is paid first.
      expect(twice.nextDue, DateTime(2026, 9, 15));
    });

    test('paid once this month is settled, with nothing left to press', () {
      final item = _on(
        _recurring(paidThrough: DateTime(2026, 9, 15)),
        DateTime(2026, 9, 20),
      );
      expect(item.status, RecurringStatus.paid);
      expect(item.isPayableNow, isFalse);
      expect(item.nextDue, DateTime(2026, 10, 15));
    });

    test('paid early, before the due date, is paid too', () {
      final item = _on(
        _recurring(paidThrough: DateTime(2026, 9, 15)),
        DateTime(2026, 9, 3),
      );
      expect(item.status, RecurringStatus.paid);
    });

    test('last month paid, this month still to come', () {
      final item = _on(
        _recurring(paidThrough: DateTime(2026, 9, 15)),
        DateTime(2026, 10, 3),
      );
      expect(item.status, RecurringStatus.upcoming);
      expect(item.isPayableNow, isTrue);
    });

    test('set up after this month\'s due day, it starts next month', () {
      final item = _on(
        _recurring(dueDay: 5, startsOn: DateTime(2026, 9, 20)),
        DateTime(2026, 9, 25),
      );
      expect(item.status, RecurringStatus.upcoming);
      expect(item.nextDue, DateTime(2026, 10, 5));
      // Next month's payment is not this month's business.
      expect(item.isPayableNow, isFalse);
    });

    test('a yearly payment outside its month is upcoming', () {
      final item = _on(
        _recurring(
          frequency: RecurrenceFrequency.yearly,
          dueDay: 10,
          dueMonth: 3,
        ),
        DateTime(2026, 10, 1),
      );
      expect(item.status, RecurringStatus.upcoming);
      expect(item.nextDue, DateTime(2027, 3, 10));
      expect(item.isPayableNow, isFalse);
    });

    test('a weekly payment is paid for its week', () {
      final gym = _recurring(
        frequency: RecurrenceFrequency.weekly,
        dueDay: DateTime.friday,
        paidThrough: DateTime(2026, 10, 2),
      );
      // Monday to Sunday around Friday 2 October.
      expect(_on(gym, DateTime(2026, 10, 4)).status, RecurringStatus.paid);
      expect(_on(gym, DateTime(2026, 10, 6)).status, RecurringStatus.upcoming);
    });

    test('automatic payments never ask for confirmation', () {
      final item = _on(
        _recurring(mode: RecurringMode.autoDeduct),
        DateTime(2026, 9, 20),
      );
      expect(item.status, RecurringStatus.overdue);
      expect(item.needsConfirmation, isFalse);
    });
  });

  test('the overview puts late payments first and adds up a month', () {
    final overview = GetRecurringOverview.overviewOf([
      _recurring(paidThrough: DateTime(2026, 9, 15), amount: 1000),
      _recurring(
        frequency: RecurrenceFrequency.weekly,
        dueDay: DateTime.monday,
        amount: 12,
      ),
      _recurring(dueDay: 1, amount: 60),
      _recurring(
        frequency: RecurrenceFrequency.yearly,
        dueDay: 10,
        dueMonth: 3,
        amount: 120,
      ),
    ], today: DateTime(2026, 9, 20));

    expect(overview.commitments.map((c) => c.status), [
      RecurringStatus.overdue,
      RecurringStatus.overdue,
      RecurringStatus.upcoming,
      RecurringStatus.paid,
    ]);
    // 1000 + 12 × 52 ÷ 12 + 60 + 120 ÷ 12.
    expect(overview.monthlySpending, closeTo(1000 + 52 + 60 + 10, 0.001));
    expect(overview.count(RecurringStatus.overdue), 2);
  });

  test('the overview adds up spending and income apart', () {
    final overview = GetRecurringOverview.overviewOf([
      _recurring(amount: 900),
      RecurringExpense(
        id: 'rec_salary',
        title: 'Salary',
        amount: 3000,
        category: const ExpenseCategory(
          id: 'cat_salary',
          name: 'Salary',
          iconName: 'payments',
          colorValue: 0,
          type: TransactionType.income,
        ),
        frequency: RecurrenceFrequency.monthly,
        dueDay: 25,
        mode: RecurringMode.autoDeduct,
        startsOn: DateTime(2026, 9, 1),
        createdAt: DateTime(2026, 9, 1),
      ),
    ], today: DateTime(2026, 9, 20));

    expect(overview.monthlySpending, 900);
    expect(overview.monthlyIncome, 3000);
  });

  group('saving', () {
    RecurringDraft draft({
      String title = 'Rent',
      double amount = 100,
      ExpenseCategory? category = _bills,
      RecurrenceFrequency frequency = RecurrenceFrequency.monthly,
      int dueDay = 15,
      int? dueMonth,
    }) => RecurringDraft(
      title: title,
      amount: amount,
      category: category,
      frequency: frequency,
      dueDay: dueDay,
      dueMonth: dueMonth,
      mode: RecurringMode.reminder,
    );

    FailureCode? codeOf(RecurringDraft d) =>
        SaveRecurringExpense.validate(d)?.code;

    test('checks the name, amount, category and due date', () {
      expect(codeOf(draft()), isNull);
      expect(codeOf(draft(title: '  ')), FailureCode.titleRequired);
      expect(codeOf(draft(title: 'x' * 41)), FailureCode.titleTooLong);
      expect(codeOf(draft(amount: 0)), FailureCode.amountRequired);
      expect(codeOf(draft(category: null)), FailureCode.categoryRequired);
      // Income repeats too, such as a salary.
      expect(
        codeOf(
          draft(
            category: const ExpenseCategory(
              id: 'cat_salary',
              name: 'Salary',
              iconName: 'payments',
              colorValue: 0,
              type: TransactionType.income,
            ),
          ),
        ),
        isNull,
      );
      expect(codeOf(draft(dueDay: 32)), FailureCode.dueDayInvalid);
      expect(
        codeOf(draft(frequency: RecurrenceFrequency.weekly, dueDay: 8)),
        FailureCode.dueDayInvalid,
      );
      expect(
        codeOf(draft(frequency: RecurrenceFrequency.yearly, dueDay: 10)),
        FailureCode.dueDayInvalid,
      );
      expect(
        codeOf(
          draft(frequency: RecurrenceFrequency.yearly, dueDay: 30, dueMonth: 2),
        ),
        FailureCode.dueDayInvalid,
      );
      expect(
        codeOf(
          draft(frequency: RecurrenceFrequency.yearly, dueDay: 29, dueMonth: 2),
        ),
        isNull,
      );
    });

    test('moving the due day keeps this month paid', () {
      final before = _recurring(paidThrough: DateTime(2026, 9, 15));
      final after = before.copyWith(dueDay: 20);
      final carried = SaveRecurringExpense.carriedPaidThrough(
        before,
        after,
        today: DateTime(2026, 9, 17),
      );
      expect(carried, DateTime(2026, 9, 20));
      expect(
        _on(
          after.copyWith(paidThrough: () => carried),
          DateTime(2026, 9, 17),
        ).status,
        RecurringStatus.paid,
      );
    });

    test('a new frequency never makes anything overdue', () {
      final before = _recurring(paidThrough: DateTime(2026, 8, 15));
      final after = before.copyWith(
        frequency: RecurrenceFrequency.weekly,
        dueDay: DateTime.monday,
      );
      final carried = SaveRecurringExpense.carriedPaidThrough(
        before,
        after,
        today: DateTime(2026, 9, 30),
      );
      expect(carried, DateTime(2026, 9, 29));
      expect(
        _on(
          after.copyWith(paidThrough: () => carried),
          DateTime(2026, 9, 30),
        ).status,
        isNot(RecurringStatus.overdue),
      );
    });

    test('a new payment counts from today', () async {
      final categories = FakeCategoryRepository();
      final repository = FakeRecurringRepository(
        categories,
        FakeExpenseRepository(categories),
      );
      final saved = await SaveRecurringExpense(repository)(
        draft(title: '  Rent  '),
        today: DateTime(2026, 9, 30, 14),
      );
      final created = saved.dataOrNull!;
      expect(created.title, 'Rent');
      expect(created.startsOn, DateTime(2026, 9, 30));
      expect(created.dueMonth, isNull);
    });
  });

  group('auto-deduct', () {
    late FakeCategoryRepository categories;
    late FakeExpenseRepository expenses;
    late FakeRecurringRepository repository;

    setUp(() {
      categories = FakeCategoryRepository();
      expenses = FakeExpenseRepository(categories);
      repository = FakeRecurringRepository(categories, expenses);
    });

    test('catches up on every payment missed, each on its own date', () async {
      repository
        ..seed(
          title: 'Internet',
          amount: 30,
          dueDay: 5,
          mode: RecurringMode.autoDeduct,
          startsOn: DateTime(2026, 7, 1),
        )
        ..seed(
          title: 'Rent',
          amount: 900,
          dueDay: 1,
          startsOn: DateTime(2026, 7, 1),
        );

      final logged = await LogDueRecurring(repository)(
        today: DateTime(2026, 9, 30),
      );

      expect(logged.dataOrNull, 3);
      expect(expenses.expenses.map((e) => e.date), [
        DateTime(2026, 7, 5),
        DateTime(2026, 8, 5),
        DateTime(2026, 9, 5),
      ]);
      expect(
        expenses.expenses.every((e) => e.description == 'Internet'),
        isTrue,
      );
      // The reminder waits for the user.
      expect(repository.recurring.last.paidThrough, isNull);
    });

    test('recurring income is logged as income', () async {
      repository.seed(
        title: 'Salary',
        amount: 3000,
        categoryId: 'cat_salary',
        dueDay: 25,
        mode: RecurringMode.autoDeduct,
        startsOn: DateTime(2026, 9, 1),
      );

      await LogDueRecurring(repository)(today: DateTime(2026, 9, 30));

      final salary = expenses.expenses.single;
      expect(salary.isIncome, isTrue);
      expect(salary.amount, 3000);
      expect(salary.date, DateTime(2026, 9, 25));
      // Income adds nothing to the month's spending.
      expect(salary.spending, 0);
    });

    test('running again logs nothing twice', () async {
      repository.seed(
        title: 'Internet',
        amount: 30,
        dueDay: 5,
        mode: RecurringMode.autoDeduct,
        startsOn: DateTime(2026, 9, 1),
      );
      final log = LogDueRecurring(repository);
      await log(today: DateTime(2026, 9, 30));
      final again = await log(today: DateTime(2026, 9, 30));

      expect(again.dataOrNull, 0);
      expect(expenses.expenses, hasLength(1));
    });

    test('marking paid logs the oldest payment today', () async {
      final rent = repository.seed(
        title: 'Rent',
        amount: 900,
        dueDay: 1,
        startsOn: DateTime(2026, 8, 1),
      );
      final now = DateTime(2026, 9, 30, 9);
      final payment = (await MarkRecurringPaid(repository)(
        rent,
        now: now,
      )).dataOrNull!;

      expect(payment.due, DateTime(2026, 8, 1));
      expect(expenses.expenses.single.date, now);
      expect(expenses.expenses.single.amount, 900);

      // A second tap with the same stale item is refused, not doubled.
      final again = await repository.recordPayment(
        rent,
        due: DateTime(2026, 8, 1),
        paidAt: now,
      );
      expect(again.failureOrNull?.code, FailureCode.alreadyPaid);
      expect(expenses.expenses, hasLength(1));
      expect(again, isA<ResultFailure<Object?>>());
    });
  });
}
