import '../../../core/l10n/app_strings.dart';
import '../../../core/utils/category_icons.dart';
import '../../categories/domain/entities/expense_category.dart';
import '../../categories/presentation/category_label.dart';

/// The shape the prompt asks for, as a complete example. Kept on its own so
/// a test can import it: if the backup format ever changes in a way the
/// prompt no longer matches, that test fails.
const String importPromptExample = '''
{
  "format": "my_budget_backup",
  "categories": [
    {"id": "imp_cat_1", "name": "Coffee", "type": "expense", "icon": "local_cafe"}
  ],
  "expenses": [
    {"id": "imp_1", "amount": 4.5, "category_id": "imp_cat_1", "date": "2026-08-14", "description": "Latte"},
    {"id": "imp_2", "amount": 1200, "category_id": "cat_salary", "date": "2026-08-01", "description": "August salary"}
  ]
}''';

/// What the user pastes, with their own data, into an AI chat (ChatGPT,
/// Gemini, Claude, …) to turn it into a file the app imports.
///
/// Written in English, which every model follows best, whatever language
/// the app and the data are in. It lists the user's own [categories] with
/// their ids, so the AI files transactions under them instead of inventing
/// near-duplicates.
///
/// [batch] starts every id the AI makes up. A fresh one per prompt keeps two
/// imports from different sources from overwriting each other on *Merge*,
/// while the parts of one large import share it.
String buildImportPrompt(
  List<ExpenseCategory> categories,
  AppStrings strings, {
  required String batch,
}) {
  String line(ExpenseCategory category) =>
      '- ${category.id} | ${categoryLabel(strings, category)} | '
      '${category.isIncome ? 'income' : 'expense'}';

  return '''
You convert personal finance data into a JSON file for the "My Budget" app.
I will attach or paste my data after this message: a CSV or Excel export, another app's backup, a bank statement or plain notes.

Reply with ONLY one JSON object in exactly this shape, with no comments and no text before or after it:

$importPromptExample

Rules:
1. "expenses" holds every transaction, spending and income alike. A transaction is income when its category's type is "income".
2. "amount" is always a positive number (no currency symbol, no thousands separator), even for spending.
3. "date" is the day of the transaction as "YYYY-MM-DD".
4. "description" is optional: the note, payee or merchant, if there is one.
5. "category_id" must be one of the ids below when one fits. These are my categories (id | name | type):
${categories.map(line).join('\n')}
6. Only when nothing above fits, add a new category to "categories" with the id "${batch}_cat_1", "${batch}_cat_2", …, a short name in the language of my data, "type" "expense" or "income", and the "icon" that fits it best from this list: ${CategoryIcons.names.join(', ')}. Do not add categories that already exist above.
7. Give every transaction a unique id "${batch}_1", "${batch}_2", … (the example uses "imp" instead of "$batch"; use "$batch").
8. Skip rows that are not transactions: totals, balances, headers, transfers between my own accounts.
9. If there are too many transactions for one reply, split them into several complete JSON objects (each with "format", "categories" and "expenses"). Keep the ids unique across all of them, and repeat in each object the new categories its transactions use. I will import each one.
''';
}

/// A short id prefix unique to one prompt, such as `imp_mf2k8q`.
String newImportBatch(DateTime now) =>
    'imp_${now.millisecondsSinceEpoch.toRadixString(36)}';
