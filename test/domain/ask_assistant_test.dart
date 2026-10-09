import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/analyses/domain/usecases/get_month_analysis.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_message.dart';
import 'package:my_budget/features/assistant/domain/usecases/ask_assistant.dart';
import 'package:my_budget/features/assistant/domain/usecases/build_spending_summary.dart';
import 'package:my_budget/features/budgets/domain/usecases/get_budget_status.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

import '../presentation/fakes.dart';

class _BrokenExpenses extends FakeExpenseRepository {
  _BrokenExpenses(super.categories);

  @override
  Future<ApiResult<List<Expense>>> getTransactionsForMonth(Month month) async =>
      const ResultFailure(DatabaseFailure());
}

void main() {
  late FakeCategoryRepository categories;
  late FakeExpenseRepository expenses;
  late FakeAssistantRepository assistant;
  late AskAssistant ask;

  final now = DateTime(2026, 10, 10);

  AskAssistant askOver(FakeExpenseRepository expenses) => AskAssistant(
    repository: assistant,
    buildSummary: BuildSpendingSummary(
      getMonthAnalysis: GetMonthAnalysis(expenses),
      getBudgetStatus: GetBudgetStatus(
        budgetRepository: FakeBudgetRepository(),
        expenseRepository: expenses,
        categoryRepository: categories,
      ),
    ),
  );

  Future<ApiResult<String>> send(
    String question, {
    List<AssistantMessage> history = const [],
  }) => ask(
    question: question,
    history: history,
    labelOf: (category) => category.name,
    currency: r'$',
    languageCode: 'ar',
    now: now,
  );

  setUp(() {
    categories = FakeCategoryRepository();
    expenses = FakeExpenseRepository(categories);
    assistant = FakeAssistantRepository();
    ask = askOver(expenses);
  });

  group('validate', () {
    test('needs some text', () {
      expect(AskAssistant.validate(''), FailureCode.questionRequired);
      expect(AskAssistant.validate('   \n '), FailureCode.questionRequired);
    });

    test('allows up to 500 characters, ignoring surrounding spaces', () {
      expect(AskAssistant.validate('a' * 500), isNull);
      expect(AskAssistant.validate('  ${'a' * 500}  '), isNull);
      expect(AskAssistant.validate('a' * 501), FailureCode.questionTooLong);
    });
  });

  test('an invalid question never reaches the server', () async {
    final result = await send('  ');

    expect(result.failureOrNull?.code, FailureCode.questionRequired);
    expect(assistant.asked, isEmpty);
  });

  test('sends the trimmed question, language and a summary', () async {
    assistant.replies.add('Spend less on food.');

    final result = await send('  Where can I save?  ');

    expect(result.dataOrNull, 'Spend less on food.');
    final sent = assistant.asked.single;
    expect(sent.question, 'Where can I save?');
    expect(sent.languageCode, 'ar');
    expect(sent.summary.currency, r'$');
    expect(sent.summary.months.first.period, '2026-10');
  });

  test('builds a fresh summary for every question', () async {
    await expenses.addExpense(
      amount: 10,
      categoryId: 'cat_food',
      date: DateTime(2026, 10, 2),
    );
    await send('How much?');
    await expenses.addExpense(
      amount: 5,
      categoryId: 'cat_food',
      date: DateTime(2026, 10, 3),
    );
    await send('And now?');

    expect(assistant.asked[0].summary.months.first.spent, 10);
    expect(assistant.asked[1].summary.months.first.spent, 15);
  });

  test('sends only the last six messages of history', () async {
    final history = [
      for (var i = 0; i < 8; i++)
        i.isEven
            ? AssistantMessage.user('q$i')
            : AssistantMessage.assistant('a$i'),
    ];

    await send('Next?', history: history);

    expect(assistant.asked.single.history, history.sublist(2));
  });

  test('passes a summary failure on without asking', () async {
    ask = askOver(_BrokenExpenses(categories));

    final result = await send('How much?');

    expect(result.failureOrNull, isA<DatabaseFailure>());
    expect(assistant.asked, isEmpty);
  });

  test('passes the server failure on', () async {
    assistant.replies.add(const AssistantFailure(FailureCode.aiDailyLimit));

    final result = await send('How much?');

    expect(result.failureOrNull?.code, FailureCode.aiDailyLimit);
  });
}
