import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/data/datasources/category_local_data_source.dart';
import 'package:my_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:my_budget/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/recurring/data/datasources/recurring_local_data_source.dart';
import 'package:my_budget/features/recurring/data/repositories/recurring_repository_impl.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_expense.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/recurring/domain/usecases/log_due_recurring.dart';

/// Recurring payments against the real SQLite schema.
void main() {
  late AppDatabase database;
  late RecurringRepositoryImpl recurring;
  late ExpenseRepositoryImpl expenses;
  late CategoryRepositoryImpl categories;

  setUp(() {
    database = AppDatabase(inMemory: true);
    recurring = RecurringRepositoryImpl(RecurringLocalDataSourceImpl(database));
    expenses = ExpenseRepositoryImpl(ExpenseLocalDataSourceImpl(database));
    categories = CategoryRepositoryImpl(CategoryLocalDataSourceImpl(database));
  });

  tearDown(() => database.close());

  Future<RecurringExpense> create({
    String title = 'Rent',
    String categoryId = 'cat_bills',
    RecurrenceFrequency frequency = RecurrenceFrequency.monthly,
    int dueDay = 1,
    int? dueMonth,
    RecurringMode mode = RecurringMode.reminder,
    DateTime? startsOn,
  }) async => (await recurring.createRecurring(
    title: title,
    amount: 900,
    categoryId: categoryId,
    frequency: frequency,
    dueDay: dueDay,
    dueMonth: dueMonth,
    mode: mode,
    startsOn: startsOn ?? DateTime(2026, 9, 1),
  )).dataOrNull!;

  test('stores a recurring payment and reads it back', () async {
    final created = await create(
      frequency: RecurrenceFrequency.yearly,
      dueDay: 29,
      dueMonth: 2,
      mode: RecurringMode.autoDeduct,
    );

    final stored = (await recurring.getRecurring()).dataOrNull!.single;
    expect(stored, created);
    expect(stored.category.name, 'Bills');
    expect(stored.frequency, RecurrenceFrequency.yearly);
    expect(stored.dueMonth, 2);
    expect(stored.isAutomatic, isTrue);
    expect(stored.startsOn, DateTime(2026, 9, 1));
    expect(stored.paidThrough, isNull);

    // Stamped for the next cloud backup, with the day as plain text.
    final row = (await LocalRecords(database).readPending()).recurring.single;
    expect(row['starts_on'], '2026-09-01');
    expect(row['dirty'], 1);
  });

  test('edits and deletes', () async {
    final rent = await create();
    await recurring.updateRecurring(
      rent.copyWith(title: 'Flat rent', amount: 950, dueDay: 3),
    );
    final edited = (await recurring.getRecurring()).dataOrNull!.single;
    expect(edited.title, 'Flat rent');
    expect(edited.amount, 950);
    expect(edited.dueDay, 3);

    await recurring.deleteRecurring(rent.id);
    expect((await recurring.getRecurring()).dataOrNull, isEmpty);
    // Kept as a marked row, so the delete can sync.
    final row = (await LocalRecords(database).readAll()).recurring.single;
    expect(row['deleted_at'], isNotNull);
  });

  test('a payment is a transaction in the month it was paid', () async {
    final rent = await create();
    final paidAt = DateTime(2026, 9, 2, 10);

    final payment = (await recurring.recordPayment(
      rent,
      due: DateTime(2026, 9, 1),
      paidAt: paidAt,
    )).dataOrNull!;

    final month = (await expenses.getTransactionsForMonth(
      const Month(2026, 9),
    )).dataOrNull!;
    final logged = month.single;
    expect(logged.id, payment.expenseId);
    expect(logged.id, '${rent.id}_20260901');
    expect(logged.amount, 900);
    expect(logged.description, 'Rent');
    expect(logged.category.id, 'cat_bills');
    expect(logged.date, paidAt);

    final stored = (await recurring.getRecurring()).dataOrNull!.single;
    expect(stored.paidThrough, DateTime(2026, 9, 1));
  });

  test('the same payment is never logged twice', () async {
    final rent = await create();
    await recurring.recordPayment(
      rent,
      due: DateTime(2026, 9, 1),
      paidAt: DateTime(2026, 9, 1),
    );

    final again = await recurring.recordPayment(
      rent,
      due: DateTime(2026, 9, 1),
      paidAt: DateTime(2026, 9, 1),
    );

    expect(again.failureOrNull?.code, FailureCode.alreadyPaid);
    expect(
      (await expenses.getTransactionsForMonth(const Month(2026, 9))).dataOrNull,
      hasLength(1),
    );
  });

  test('undo removes the transaction and makes it due again', () async {
    final rent = await create();
    final payment = (await recurring.recordPayment(
      rent,
      due: DateTime(2026, 9, 1),
      paidAt: DateTime(2026, 9, 2),
    )).dataOrNull!;

    await recurring.undoPayment(payment);

    expect(
      (await expenses.getTransactionsForMonth(const Month(2026, 9))).dataOrNull,
      isEmpty,
    );
    final stored = (await recurring.getRecurring()).dataOrNull!.single;
    expect(stored.paidThrough, isNull);

    // Paying it again brings the same transaction back.
    final repaid = await recurring.recordPayment(
      stored,
      due: DateTime(2026, 9, 1),
      paidAt: DateTime(2026, 9, 3),
    );
    expect(repaid.isSuccess, isTrue);
    final month = (await expenses.getTransactionsForMonth(
      const Month(2026, 9),
    )).dataOrNull!;
    expect(month.single.id, payment.expenseId);
    expect(month.single.date, DateTime(2026, 9, 3));
  });

  test('deleting its category moves it to Other', () async {
    final gym = (await categories.createCategory(
      name: 'Gym',
      iconName: 'fitness_center',
      colorValue: 0xFF123456,
      type: TransactionType.expense,
    )).dataOrNull!;
    await create(title: 'Membership', categoryId: gym.id);

    await categories.deleteCategory(gym.id);

    final stored = (await recurring.getRecurring()).dataOrNull!.single;
    expect(stored.category.id, ExpenseCategory.fallbackId);
  });

  test('auto-deduct catches up once, however often it runs', () async {
    await create(
      title: 'Internet',
      dueDay: 5,
      mode: RecurringMode.autoDeduct,
      startsOn: DateTime(2026, 7, 1),
    );
    await create(title: 'Rent', dueDay: 1, startsOn: DateTime(2026, 7, 1));
    final log = LogDueRecurring(recurring);

    final first = await log(today: DateTime(2026, 9, 30));
    // Two runs at once, as a resume and a restore might start them.
    final racing = await Future.wait([
      log(today: DateTime(2026, 9, 30)),
      log(today: DateTime(2026, 9, 30)),
    ]);

    expect(first.dataOrNull, 3);
    expect(racing.map((r) => r.dataOrNull), [0, 0]);
    for (final month in [7, 8, 9]) {
      final logged = (await expenses.getTransactionsForMonth(
        Month(2026, month),
      )).dataOrNull!;
      expect(logged.single.date, DateTime(2026, month, 5));
      expect(logged.single.description, 'Internet');
    }
  });
}
