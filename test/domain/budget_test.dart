import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/budgets/domain/entities/budget_alert.dart';
import 'package:my_budget/features/budgets/domain/entities/budget_limits.dart';
import 'package:my_budget/features/budgets/domain/entities/budget_line.dart';
import 'package:my_budget/features/budgets/domain/entities/budget_status.dart';
import 'package:my_budget/features/budgets/domain/repositories/budget_repository.dart';
import 'package:my_budget/features/budgets/domain/usecases/check_budget_alerts.dart';
import 'package:my_budget/features/budgets/domain/usecases/get_budget_status.dart';
import 'package:my_budget/features/budgets/domain/usecases/set_category_budget.dart';
import 'package:my_budget/features/budgets/domain/usecases/set_monthly_budget.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

const _food = ExpenseCategory(
  id: 'cat_food',
  name: 'Food',
  iconName: 'restaurant',
  colorValue: 0xFFEF6C00,
);
const _bills = ExpenseCategory(
  id: 'cat_bills',
  name: 'Bills',
  iconName: 'receipt_long',
  colorValue: 0xFF6D4C41,
  sortOrder: 1,
);
const _august = Month(2026, 8);

int _ids = 0;

Expense _expense(
  double amount, [
  ExpenseCategory category = _food,
  Month month = _august,
]) => Expense(
  id: 'exp_${_ids++}',
  amount: amount,
  category: category,
  date: DateTime(month.year, month.month, 4),
  createdAt: DateTime(month.year, month.month, 4),
);

/// The month after the expenses in [expenses] were stored.
BudgetStatus _after(List<Expense> expenses, BudgetLimits limits) =>
    GetBudgetStatus.statusOf(
      month: _august,
      limits: limits,
      expenses: expenses,
      categories: const [_food, _bills],
    );

class _RecordingRepository implements BudgetRepository {
  final List<(String?, double?)> saved = [];

  @override
  Future<ApiResult<BudgetLimits>> getLimits() async =>
      const Success(BudgetLimits());

  @override
  Future<ApiResult<void>> saveMonthlyLimit(double? limit) async {
    saved.add((null, limit));
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> saveCategoryLimit(
    String categoryId,
    double? limit,
  ) async {
    saved.add((categoryId, limit));
    return const Success(null);
  }
}

void main() {
  group('BudgetLevel', () {
    test('is safe under 70%, a warning up to 90%, critical above', () {
      expect(BudgetLevel.of(0), BudgetLevel.safe);
      expect(BudgetLevel.of(0.69), BudgetLevel.safe);
      expect(BudgetLevel.of(0.7), BudgetLevel.warning);
      expect(BudgetLevel.of(0.9), BudgetLevel.warning);
      expect(BudgetLevel.of(0.91), BudgetLevel.critical);
      expect(BudgetLevel.of(1.5), BudgetLevel.critical);
    });
  });

  group('BudgetLine', () {
    test('reports what is left, or how far over it is', () {
      const under = BudgetLine(spent: 320, limit: 500);
      expect(under.fraction, 0.64);
      expect(under.remaining, 180);
      expect(under.isOver, isFalse);

      const over = BudgetLine(spent: 540, limit: 500);
      expect(over.remaining, -40);
      expect(over.isOver, isTrue);
      expect(over.level, BudgetLevel.critical);
    });

    test('compares in cents, so float sums do not tip a threshold', () {
      // 0.1 + 0.2 is 0.30000000000000004 in floating point.
      const line = BudgetLine(spent: 0.1 + 0.2, limit: 0.3);
      expect(line.isOver, isFalse);
      expect(line.fraction, 1);
      expect(line.remaining, 0);
    });
  });

  group('GetBudgetStatus', () {
    test('sets the month and each category against its limit', () {
      final status = _after([
        _expense(30),
        _expense(45),
        _expense(100, _bills),
      ], const BudgetLimits(monthly: 250, byCategory: {'cat_food': 100}));

      expect(status.spent, 175);
      expect(status.total, const BudgetLine(spent: 175, limit: 250));

      final food = status.categories.first;
      expect(food.category, _food);
      expect(food.line, const BudgetLine(spent: 75, limit: 100));

      // Bills has spending but no limit of its own.
      final bills = status.categories.last;
      expect(bills.spent, 100);
      expect(bills.line, isNull);
    });

    test('has no monthly line until a monthly budget is set', () {
      final status = _after([_expense(10)], const BudgetLimits());
      expect(status.total, isNull);
      expect(status.categories.every((entry) => entry.line == null), isTrue);
    });

    test('ignores a limit on a category that no longer exists', () {
      final status = _after(
        const [],
        const BudgetLimits(byCategory: {'cat_gone': 50}),
      );
      expect(status.categories.map((entry) => entry.category.id), [
        'cat_food',
        'cat_bills',
      ]);
    });

    test('watches categories from 70% up, the furthest through first', () {
      final status = _after([
        _expense(75),
        _expense(95, _bills),
      ], const BudgetLimits(byCategory: {'cat_food': 100, 'cat_bills': 100}));
      expect(status.watchList.map((entry) => entry.category.id), [
        'cat_bills',
        'cat_food',
      ]);

      final comfortable = _after([
        _expense(69),
      ], const BudgetLimits(byCategory: {'cat_food': 100}));
      expect(comfortable.watchList, isEmpty);
    });
  });

  group('CheckBudgetAlerts', () {
    const monthly100 = BudgetLimits(monthly: 100);

    test('warns when a new expense passes 80% of the monthly budget', () {
      final earlier = _expense(50);
      final saved = _expense(35);

      final alerts = CheckBudgetAlerts.crossed(
        _after([earlier, saved], monthly100),
        saved: saved,
      );

      expect(alerts, hasLength(1));
      expect(alerts.single.threshold, BudgetThreshold.nearing);
      expect(alerts.single.category, isNull);
      expect(alerts.single.line.fraction, 0.85);
    });

    test('reaching exactly 80% counts as passing it', () {
      final saved = _expense(80);
      final alerts = CheckBudgetAlerts.crossed(
        _after([saved], monthly100),
        saved: saved,
      );
      expect(alerts.single.threshold, BudgetThreshold.nearing);
    });

    test('jumping past both thresholds reports only the limit', () {
      final saved = _expense(120);
      final alerts = CheckBudgetAlerts.crossed(
        _after([saved], monthly100),
        saved: saved,
      );
      expect(alerts.single.threshold, BudgetThreshold.reached);
      expect(alerts.single.line.isOver, isTrue);
    });

    test('says nothing new while spending stays between 80% and 100%', () {
      final earlier = _expense(82);
      final saved = _expense(10);
      final alerts = CheckBudgetAlerts.crossed(
        _after([earlier, saved], monthly100),
        saved: saved,
      );
      expect(alerts, isEmpty);
    });

    test('warns once more when the limit itself is passed', () {
      final earlier = _expense(90);
      final saved = _expense(15);
      final alerts = CheckBudgetAlerts.crossed(
        _after([earlier, saved], monthly100),
        saved: saved,
      );
      expect(alerts.single.threshold, BudgetThreshold.reached);
      expect(alerts.single.line.remaining, -5);
    });

    test('warns about a category and the month together', () {
      final earlier = _expense(60, _bills);
      final saved = _expense(30);
      final alerts = CheckBudgetAlerts.crossed(
        _after([
          earlier,
          saved,
        ], const BudgetLimits(monthly: 100, byCategory: {'cat_food': 25})),
        saved: saved,
      );

      // The month is at 90 of 100; Food alone is at 30 of 25.
      expect(alerts, hasLength(2));
      expect(alerts.first.category, isNull);
      expect(alerts.first.threshold, BudgetThreshold.nearing);
      expect(alerts.last.category, _food);
      expect(alerts.last.threshold, BudgetThreshold.reached);
    });

    test('a category without a limit never warns', () {
      final saved = _expense(500, _bills);
      final alerts = CheckBudgetAlerts.crossed(
        _after([saved], const BudgetLimits(byCategory: {'cat_food': 10})),
        saved: saved,
      );
      expect(alerts, isEmpty);
    });

    test('adds up cents exactly: 3 × 26.67 passes 80 of 100', () {
      final expenses = [_expense(26.67), _expense(26.67), _expense(26.67)];
      final alerts = CheckBudgetAlerts.crossed(
        _after(expenses, monthly100),
        saved: expenses.last,
      );
      expect(alerts.single.threshold, BudgetThreshold.nearing);
    });

    group('after an edit', () {
      test('warns when raising the amount passes a threshold', () {
        final before = _expense(70);
        final saved = before.copyWith(amount: 85);
        final alerts = CheckBudgetAlerts.crossed(
          _after([saved], monthly100),
          saved: saved,
          replaced: before,
        );
        expect(alerts.single.threshold, BudgetThreshold.nearing);
      });

      test('stays quiet when lowering the amount', () {
        final before = _expense(120);
        final saved = before.copyWith(amount: 90);
        final alerts = CheckBudgetAlerts.crossed(
          _after([saved], monthly100),
          saved: saved,
          replaced: before,
        );
        expect(alerts, isEmpty);
      });

      test('moving an expense into a category counts all of it there', () {
        final before = _expense(40, _bills);
        final saved = before.copyWith(category: _food);
        final alerts = CheckBudgetAlerts.crossed(
          _after(
            [saved],
            const BudgetLimits(
              monthly: 100,
              byCategory: {'cat_food': 40, 'cat_bills': 40},
            ),
          ),
          saved: saved,
          replaced: before,
        );
        // The month's total did not change, only which category holds it.
        expect(alerts.single.category, _food);
        expect(alerts.single.threshold, BudgetThreshold.reached);
      });

      test('moving an expense into another month counts all of it there', () {
        final before = _expense(90, _food, const Month(2026, 7));
        final saved = before.copyWith(date: DateTime(2026, 8, 2));
        final alerts = CheckBudgetAlerts.crossed(
          _after([saved], monthly100),
          saved: saved,
          replaced: before,
        );
        expect(alerts.single.threshold, BudgetThreshold.nearing);
      });
    });
  });

  group('setting a budget', () {
    test('accepts a positive limit and removes with null', () async {
      final repository = _RecordingRepository();

      expect((await SetMonthlyBudget(repository)(500)).isSuccess, isTrue);
      expect(
        (await SetCategoryBudget(repository)('cat_food', 120)).isSuccess,
        isTrue,
      );
      expect((await SetMonthlyBudget(repository)(null)).isSuccess, isTrue);

      expect(repository.saved, [
        (null, 500.0),
        ('cat_food', 120.0),
        (null, null),
      ]);
    });

    test('rejects zero, negative and absurd limits before storing', () async {
      final repository = _RecordingRepository();
      final monthly = SetMonthlyBudget(repository);
      final category = SetCategoryBudget(repository);

      expect(
        (await monthly(0)).failureOrNull?.code,
        FailureCode.amountRequired,
      );
      expect(
        (await category('cat_food', -5)).failureOrNull?.code,
        FailureCode.amountRequired,
      );
      expect(
        (await monthly(double.nan)).failureOrNull?.code,
        FailureCode.amountRequired,
      );
      expect(
        (await monthly(2e9)).failureOrNull?.code,
        FailureCode.amountTooLarge,
      );
      expect(
        (await category('', 10)).failureOrNull?.code,
        FailureCode.categoryRequired,
      );
      expect(repository.saved, isEmpty);
    });
  });
}
