import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/analyses/domain/usecases/get_month_analysis.dart';
import 'package:my_budget/features/assistant/domain/entities/spending_summary.dart';
import 'package:my_budget/features/assistant/domain/usecases/build_spending_summary.dart';
import 'package:my_budget/features/budgets/domain/usecases/get_budget_status.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_sharing.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction_type.dart';
import 'package:my_budget/features/people/domain/usecases/get_people.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/recurring/domain/usecases/get_recurring_overview.dart';

import '../presentation/fakes.dart';

/// Fails every month read, the way a broken database would.
class _BrokenExpenses extends FakeExpenseRepository {
  _BrokenExpenses(super.categories);

  @override
  Future<ApiResult<List<Expense>>> getTransactionsForMonth(Month month) async =>
      const ResultFailure(DatabaseFailure('disk I/O error'));
}

void main() {
  late FakeCategoryRepository categories;
  late FakeExpenseRepository expenses;
  late FakeBudgetRepository budgets;
  late FakeRecurringRepository recurring;
  late FakePeopleRepository people;
  late BuildSpendingSummary build;

  final now = DateTime(2026, 10, 10);
  String labelOf(ExpenseCategory category) => 'L:${category.name}';

  BuildSpendingSummary buildOver(FakeExpenseRepository expenses) =>
      BuildSpendingSummary(
        getMonthAnalysis: GetMonthAnalysis(expenses),
        getBudgetStatus: GetBudgetStatus(
          budgetRepository: budgets,
          expenseRepository: expenses,
          categoryRepository: categories,
        ),
        expenseRepository: expenses,
        getRecurringOverview: GetRecurringOverview(recurring),
        getPeople: GetPeople(people),
      );

  setUp(() {
    categories = FakeCategoryRepository();
    expenses = FakeExpenseRepository(categories);
    budgets = FakeBudgetRepository();
    recurring = FakeRecurringRepository(categories, expenses);
    people = FakePeopleRepository();
    build = buildOver(expenses);
  });

  Future<void> add(
    double amount,
    DateTime date, {
    String category = 'cat_food',
    String? description,
  }) => expenses.addExpense(
    amount: amount,
    categoryId: category,
    date: date,
    description: description,
  );

  test('covers three explicit months, newest first, with the analyses '
      'figures', () async {
    await add(30, DateTime(2026, 10, 2));
    await add(10, DateTime(2026, 10, 4), category: 'cat_bills');
    await add(500, DateTime(2026, 10, 1), category: 'cat_salary');
    await add(40, DateTime(2026, 9, 12));
    await add(25, DateTime(2026, 8, 3));
    budgets
      ..monthly = 100
      ..byCategory['cat_food'] = 50;

    final summary = (await build(
      labelOf: labelOf,
      currency: r'$',
      now: now,
    )).dataOrNull!;

    expect(summary.currency, r'$');
    expect(summary.generatedOn, '2026-10-10');
    expect(
      [for (final m in summary.months) m.period],
      ['2026-10', '2026-09', '2026-08'],
    );

    final october = summary.months.first;
    final analysis = (await GetMonthAnalysis(expenses)(
      const Month(2026, 10),
      now: now,
    )).dataOrNull!;
    expect(october.isCurrent, isTrue);
    expect(october.spent, analysis.total);
    expect(october.spent, 40);
    expect(october.income, 500);
    expect(october.expenseCount, 2);
    expect(october.daysCounted, 10);
    expect(october.dailyAverage, analysis.dailyAverage);
    expect(october.previousMonthSpent, 40);
    expect(october.changeVsPrevious, 0);
    expect(october.projectedMonthEnd, analysis.projectedTotal(now));
    expect(october.topDayDate, '2026-10-02');
    expect(october.spendingByCategory.first.name, 'L:Food');
    expect(october.spendingByCategory.first.share, 0.75);
    expect(october.incomeByCategory.single.name, 'L:Salary');

    final september = summary.months[1];
    expect(september.isCurrent, isFalse);
    expect(september.projectedMonthEnd, isNull);
    expect(september.daysCounted, 30);

    expect(summary.budget.period, '2026-10');
    expect(summary.budget.monthlyLimit, 100);
    expect(summary.budget.spent, 40);
    expect(summary.budget.categories.single.name, 'L:Food');
    expect(summary.budget.categories.single.limit, 50);

    expect(summary.trend, hasLength(GetMonthAnalysis.trendLength));
    expect(summary.trend.last, ('2026-10', 40.0));
  });

  test('sends no descriptions, ids or single transactions', () async {
    await add(
      999.99,
      DateTime(2026, 10, 3),
      description: 'Dinner with Sara at Nile Bistro',
    );

    final summary = (await build(
      labelOf: labelOf,
      currency: 'EGP',
      now: now,
    )).dataOrNull!;
    final encoded = jsonEncode(summary.toJson());

    expect(encoded, isNot(contains('Sara')));
    expect(encoded, isNot(contains('Bistro')));
    expect(encoded, isNot(contains('exp_')));
    expect(encoded, isNot(contains('cat_')));
    expect(encoded, isNot(contains('largestExpense')));
    expect(encoded, isNot(contains('description')));
    // The total is there, as an aggregate.
    expect(encoded, contains('999.99'));
  });

  test('a fresh summary reflects data added since the last one', () async {
    await add(10, DateTime(2026, 10, 3));
    final before = (await build(
      labelOf: labelOf,
      currency: '',
      now: now,
    )).dataOrNull!;
    await add(15, DateTime(2026, 10, 4));
    final after = (await build(
      labelOf: labelOf,
      currency: '',
      now: now,
    )).dataOrNull!;

    expect(before.months.first.spent, 10);
    expect(after.months.first.spent, 25);
  });

  test('passes a database failure on', () async {
    build = buildOver(_BrokenExpenses(categories));

    final result = await build(labelOf: labelOf, currency: '', now: now);

    expect(result.failureOrNull, isA<DatabaseFailure>());
  });

  group('size limit', () {
    SpendingSummary withCategories(int count, {int nameLength = 80}) {
      final share = 1 / count;
      return SpendingSummary(
        currency: r'$',
        generatedOn: '2026-10-10',
        months: [
          SummaryMonth(
            period: '2026-10',
            isCurrent: true,
            daysCounted: 10,
            spent: count * 10,
            income: 0,
            expenseCount: count,
            dailyAverage: count.toDouble(),
            previousMonthSpent: 0,
            spendingByCategory: [
              for (var i = 0; i < count; i++)
                SummaryCategory(
                  name: '$i'.padRight(nameLength, 'x'),
                  total: 10,
                  share: share,
                ),
            ],
            incomeByCategory: const [],
          ),
        ],
        budget: const SummaryBudget(
          period: '2026-10',
          spent: 0,
          categories: [],
        ),
        trend: const [],
      );
    }

    test('keeps a small summary as it is', () {
      final small = withCategories(3);
      expect(BuildSpendingSummary.fitted(small).dataOrNull, small);
    });

    test('merges the smaller categories until it fits, keeping the total', () {
      final big = withCategories(120);
      expect(
        BuildSpendingSummary.sizeOf(big),
        greaterThan(BuildSpendingSummary.maxBytes),
      );

      final fitted = BuildSpendingSummary.fitted(big).dataOrNull!;
      final list = fitted.months.single.spendingByCategory;

      expect(
        BuildSpendingSummary.sizeOf(fitted),
        lessThanOrEqualTo(BuildSpendingSummary.maxBytes),
      );
      expect(list, hasLength(BuildSpendingSummary.categoryCaps.first));
      expect(list.last.name, BuildSpendingSummary.othersName);
      expect(list.fold<double>(0, (sum, c) => sum + c.total), 1200);
    });

    test('fails when even the shortest lists do not fit', () {
      final huge = withCategories(6, nameLength: 3000);

      final result = BuildSpendingSummary.fitted(huge);

      expect(result.failureOrNull?.code, FailureCode.summaryTooLarge);
    });
  });

  group('what the user shares', () {
    Future<Map<String, Object?>> sent(AssistantSharing sharing) async {
      final summary = (await build(
        labelOf: labelOf,
        currency: 'EGP',
        sharing: sharing,
        now: now,
      )).dataOrNull!;
      return jsonDecode(jsonEncode(summary.toJson())) as Map<String, Object?>;
    }

    setUp(() async {
      await add(120, DateTime(2026, 10, 3), description: 'Lunch with Sara');
      await add(80, DateTime(2026, 9, 20), description: 'Taxi');
      await add(15, DateTime(2026, 4, 2), description: 'Old coffee');
      await recurring.createRecurring(
        title: 'Rent',
        amount: 3000,
        categoryId: 'cat_bills',
        frequency: RecurrenceFrequency.monthly,
        dueDay: 1,
        mode: RecurringMode.reminder,
        startsOn: DateTime(2026, 1, 1),
      );
      final sara = (await people.addPerson(
        name: 'Sara',
        colorValue: 0xFF000000,
      )).dataOrNull!;
      await people.addTransaction(
        personId: sara.id,
        amount: 50,
        type: PersonTransactionType.iPaidForThem,
        date: DateTime(2026, 10, 1),
      );
    });

    test('by default it is the totals summary, exactly as before', () async {
      final json = await sent(AssistantSharing.defaults);
      expect(json.keys, {
        'currency',
        'generatedOn',
        'note',
        'months',
        'budget',
        'trend',
      });
      expect(
        [for (final m in json['months']! as List) (m as Map)['period']],
        ['2026-10', '2026-09', '2026-08'],
      );
      final encoded = jsonEncode(json);
      for (final secret in ['Sara', 'Lunch', 'Taxi', 'Rent']) {
        expect(encoded, isNot(contains(secret)), reason: secret);
      }
    });

    test('transactions in the period, newest first, without notes', () async {
      final json = await sent(const AssistantSharing(transactions: true));
      final list = json['transactions']! as List;
      expect(list, [
        {
          'date': '2026-10-03',
          'type': 'expense',
          'amount': 120.0,
          'category': 'L:Food',
        },
        {
          'date': '2026-09-20',
          'type': 'expense',
          'amount': 80.0,
          'category': 'L:Food',
        },
      ]);
      expect(jsonEncode(json), isNot(contains('Lunch')));
      expect(json.containsKey('olderTransactionsLeftOut'), isFalse);
    });

    test('notes go only with transactions', () async {
      final notesOnly = await sent(const AssistantSharing(descriptions: true));
      expect(notesOnly.containsKey('transactions'), isFalse);
      expect(jsonEncode(notesOnly), isNot(contains('Lunch')));

      final both = await sent(
        const AssistantSharing(transactions: true, descriptions: true),
      );
      expect(
        ((both['transactions']! as List).first as Map)['note'],
        'Lunch with Sara',
      );
    });

    test('recurring payments and people, each only when shared', () async {
      final json = await sent(
        const AssistantSharing(recurring: true, people: true),
      );
      final rent = (json['recurring']! as List).single as Map;
      expect(rent['title'], 'Rent');
      expect(rent['frequency'], 'monthly');
      expect(rent['type'], 'expense');
      final sara = (json['people']! as List).single as Map;
      expect(sara, {'name': 'Sara', 'balance': 50.0, 'openTransactions': 1});
      expect(json.containsKey('transactions'), isFalse);
    });

    test('a longer preset covers more months', () async {
      final json = await sent(
        const AssistantSharing(
          range: AssistantRange.last6Months,
          transactions: true,
        ),
      );
      expect(json['months'], hasLength(6));
      expect(
        [for (final t in json['transactions']! as List) (t as Map)['date']],
        // May to October: April's is outside.
        ['2026-10-03', '2026-09-20'],
      );

      final year = await sent(
        const AssistantSharing(
          range: AssistantRange.thisYear,
          transactions: true,
        ),
      );
      expect(year['months'], hasLength(10));
      expect((year['transactions']! as List).length, 3);
    });

    test('a custom range sends its own totals and its transactions', () async {
      final json = await sent(
        AssistantSharing(
          range: AssistantRange.custom,
          customStart: DateTime(2026, 9, 15),
          customEnd: DateTime(2026, 10, 2),
          transactions: true,
        ),
      );
      final range = json['range']! as Map;
      expect(range['from'], '2026-09-15');
      expect(range['to'], '2026-10-02');
      expect(range['spent'], 80.0);
      expect(
        [for (final m in json['months']! as List) (m as Map)['period']],
        ['2026-10', '2026-09'],
      );
      expect(
        [for (final t in json['transactions']! as List) (t as Map)['date']],
        ['2026-09-20'],
      );
    });

    test('too many transactions: the newest that fit, and a count of the '
        'rest', () async {
      for (var day = 1; day <= 28; day++) {
        for (var i = 0; i < 20; i++) {
          await add(1.0 + i, DateTime(2026, 8, day), description: 'n$i');
        }
      }
      final json = await sent(
        const AssistantSharing(transactions: true, descriptions: true),
      );
      final kept = json['transactions']! as List;
      final leftOut = json['olderTransactionsLeftOut']! as int;
      expect(leftOut, greaterThan(0));
      expect(kept.length + leftOut, 2 + 28 * 20);
      expect((kept.first as Map)['date'], '2026-10-03');
      expect(
        utf8.encode(jsonEncode(json)).length,
        lessThanOrEqualTo(BuildSpendingSummary.maxTotalBytes),
      );
    });
  });
}
