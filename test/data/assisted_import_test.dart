import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/l10n/app_strings.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/data_management/data/codecs/assisted_import.dart';
import 'package:my_budget/features/data_management/data/codecs/backup_codec.dart';
import 'package:my_budget/features/data_management/presentation/import_prompt.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';

/// Files an AI chat writes from the import prompt: completed by
/// [AssistedImport], then held to the same rules as any backup.
void main() {
  final now = DateTime(2026, 9, 10, 8);

  DecodedBackup read(String text) =>
      BackupCodec.decodeJson(AssistedImport.prepare(text, now: now));

  test('the example in the prompt imports as it stands', () {
    final backup = read(importPromptExample);

    expect(backup.records.categories.single['id'], 'imp_cat_1');
    expect(backup.records.categories.single['type'], 'expense');
    final expenses = backup.records.expenses;
    expect(expenses, hasLength(2));
    expect(expenses.first['amount'], 4.5);
    expect(expenses.first['month_key'], '2026-08');
    expect(
      DateTime.fromMillisecondsSinceEpoch(expenses.first['date']! as int),
      DateTime(2026, 8, 14, 12),
    );
    expect(expenses.last['category_id'], 'cat_salary');
  });

  test('finds the JSON inside a chat reply', () {
    final backup = read('''
Here is your file:
```json
{"expenses": [{"id": "a", "amount": 3, "category_id": "cat_food", "date": "2026-07-31"}]}
```
Let me know if you need anything else.''');

    expect(backup.records.expenses.single['month_key'], '2026-07');
    expect(backup.records.people, isEmpty);
  });

  test('forgives what spreadsheets and models get wrong', () {
    final backup = read(
      jsonEncode({
        'expenses': [
          // A bank export's negative spending, text amount, seconds.
          {
            'amount': '-1,250.75',
            'category_id': 'cat_bills',
            'date': 1785000000,
          },
          {'amount': 9, 'date': '2026-08-02T18:30:00', 'description': '  '},
        ],
      }),
    );

    final [first, second] = backup.records.expenses;
    expect(first['id'], 'imp_1');
    expect(first['amount'], 1250.75);
    expect(first['date'], 1785000000 * 1000);
    expect(second['id'], 'imp_2');
    expect(second['category_id'], ExpenseCategory.fallbackId);
    expect(second['description'], isNull);
    expect(second['updated_at'], now.millisecondsSinceEpoch);
  });

  test('a real backup passes through unchanged', () {
    final original = jsonEncode({
      'format': BackupCodec.format,
      'schema_version': BackupCodec.schemaVersion,
      'categories': <Object?>[],
      'expenses': [
        {
          'id': 'e1',
          'amount': 5,
          'description': null,
          'category_id': 'cat_food',
          'date': 1786000000000,
          'month_key': '2026-08',
          'created_at': 1786000000001,
          'updated_at': 1786000000002,
          'deleted_at': null,
        },
      ],
      'settings': <Object?>[],
      'recurring_expenses': <Object?>[],
      'people': <Object?>[],
      'settlements': <Object?>[],
      'person_transactions': <Object?>[],
      'person_transaction_edits': <Object?>[],
    });

    expect(
      read(original).records.expenses.single,
      BackupCodec.decode(original).records.expenses.single,
    );
  });

  test('still rejects what cannot be data', () {
    Matcher fails(FailureCode code) =>
        throwsA(isA<FileFailure>().having((f) => f.code, 'code', code));

    expect(
      () => read('Sorry, I cannot help with that.'),
      fails(FailureCode.backupNotRecognized),
    );
    expect(
      () => read('{"name": "something else"}'),
      fails(FailureCode.backupNotRecognized),
    );
    expect(
      () => read('{"expenses": [{"amount": 0, "date": "2026-08-01"}]}'),
      fails(FailureCode.backupDamaged),
    );
    expect(
      () => read('{"expenses": [{"amount": 5, "date": "last Tuesday"}]}'),
      fails(FailureCode.backupDamaged),
    );
  });

  test('the prompt lists every category and one id prefix', () {
    const categories = [
      ExpenseCategory(
        id: 'cat_food',
        name: 'Food',
        iconName: 'restaurant',
        colorValue: 0xFFEF6C00,
        isDefault: true,
      ),
      ExpenseCategory(
        id: 'c_coffee',
        name: 'قهوة',
        iconName: 'coffee',
        colorValue: 0xFF6D4C41,
      ),
      ExpenseCategory(
        id: 'cat_salary',
        name: 'Salary',
        iconName: 'payments',
        colorValue: 0xFF2E7D32,
        type: TransactionType.income,
        isDefault: true,
      ),
    ];

    final prompt = buildImportPrompt(
      categories,
      const AppStringsAr(),
      batch: 'imp_test',
    );

    expect(
      prompt,
      contains(
        '- cat_food | ${const AppStringsAr().defaultCategoryName('cat_food')} | expense',
      ),
    );
    expect(prompt, contains('- c_coffee | قهوة | expense'));
    expect(prompt, contains('- cat_salary |'));
    expect(prompt, contains('| income'));
    expect(prompt, contains('"imp_test_1"'));
    expect(prompt, contains('"imp_test_cat_1"'));
    expect(prompt, contains(importPromptExample));
  });

  test('new categories get a known icon and different colours', () {
    final json =
        AssistedImport.prepare(
              jsonEncode({
                'categories': [
                  {'name': 'Coffee', 'icon': 'local_cafe'},
                  {'name': 'Rent', 'icon': 'not_an_icon'},
                  {'name': 'Pets', 'icon_name': 'pets', 'color_value': 1},
                ],
              }),
              now: now,
              iconNames: const {'local_cafe', 'pets', 'category'},
              palette: const [10, 20],
            )
            as Map<String, dynamic>;

    final [coffee, rent, pets] = json['categories'] as List;
    expect(coffee['icon_name'], 'local_cafe');
    expect(coffee.containsKey('icon'), isFalse);
    expect(rent['icon_name'], AssistedImport.defaultIcon);
    expect([coffee['color_value'], rent['color_value']], [10, 20]);
    // What the file already says is kept.
    expect(pets['icon_name'], 'pets');
    expect(pets['color_value'], 1);
  });
}
