import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/domain/entities/category_name.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/categories/domain/usecases/create_category.dart';
import 'package:my_budget/features/categories/domain/usecases/update_category.dart';

import '../presentation/fakes.dart';

/// A category name can be used once per type, however it is typed.
void main() {
  group('two names are the same', () {
    for (final (a, b) in [
      ('Food', 'food'),
      ('Food', '  FOOD '),
      ('Eating out', 'eating   out'),
      ('أكل', 'اكل'),
      ('إيجار', 'ايجار'),
      ('هدية', 'هديه'),
      ('مستشفى', 'مستشفي'),
      ('قَهْوَة', 'قهوه'),
      ('قـــهوة', 'قهوة'),
      ('کتاب', 'كتاب'),
    ]) {
      test('"$a" and "$b"', () {
        expect(CategoryName.key(a), CategoryName.key(b));
      });
    }

    test('but different words stay different', () {
      expect(CategoryName.key('Food'), isNot(CategoryName.key('Foods')));
      expect(CategoryName.key('أكل'), isNot(CategoryName.key('أكلة')));
    });
  });

  group('adding and renaming', () {
    late FakeCategoryRepository categories;

    setUp(() => categories = FakeCategoryRepository());

    Future<ApiResult<Object?>> add(
      String name, [
      TransactionType type = TransactionType.expense,
    ]) => CreateCategory(categories)(
      name: name,
      iconName: 'category',
      colorValue: 0,
      type: type,
    );

    Matcher refusedAsTaken() => isA<ResultFailure<Object?>>().having(
      (result) => result.failure.code,
      'code',
      FailureCode.categoryNameTaken,
    );

    test('a name already used is refused, however it is typed', () async {
      expect(await add('food'), refusedAsTaken());
      expect(await add('  BILLS '), refusedAsTaken());

      expect(await add('Coffee'), isA<Success<Object?>>());
      expect(await add('coffee'), refusedAsTaken());
    });

    test(
      'the same name may be used once for spending and once for income',
      () async {
        expect(await add('Gifts'), isA<Success<Object?>>());
        expect(
          await add('Gifts', TransactionType.income),
          isA<Success<Object?>>(),
        );
        expect(await add('gifts', TransactionType.income), refusedAsTaken());
      },
    );

    test('renaming to another category\'s name is refused', () async {
      final food = categories.categories.firstWhere((c) => c.id == 'cat_food');
      final rename = UpdateCategory(categories);

      expect(await rename(food.copyWith(name: 'Bills')), refusedAsTaken());
      // Keeping its own name, or changing only its case, is fine.
      expect(
        await rename(food.copyWith(name: 'FOOD')),
        isA<Success<Object?>>(),
      );
    });
  });
}
