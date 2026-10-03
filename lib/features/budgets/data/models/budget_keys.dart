import '../../domain/entities/budget_limits.dart';

/// How budgets are stored: rows in the `settings` table under their own
/// `budget.` keys. Shared by the budgets data source and the exports, which
/// read the same rows.
///
/// A removed budget is stored as an empty value rather than deleted. Settings
/// rows carry no deleted marker, so only a newer row can take the removal to
/// the cloud and to the user's other phones.
abstract final class BudgetKeys {
  static const String monthly = 'budget.monthly';
  static const String categoryPrefix = 'budget.category.';

  static String category(String categoryId) => '$categoryPrefix$categoryId';

  /// The stored value for [limit]; empty for a removed budget.
  static String encode(double? limit) => limit == null ? '' : '$limit';

  /// The budgets among [rows] of the `settings` table. Anything unreadable,
  /// which only a damaged copy could hold, counts as no budget.
  static BudgetLimits fromRows(Iterable<Map<String, Object?>> rows) {
    double? monthlyLimit;
    final byCategory = <String, double>{};
    for (final row in rows) {
      final key = row['key']! as String;
      final limit = _decode(row['value']! as String);
      if (limit == null) continue;
      if (key == monthly) {
        monthlyLimit = limit;
      } else if (key.startsWith(categoryPrefix) &&
          key.length > categoryPrefix.length) {
        byCategory[key.substring(categoryPrefix.length)] = limit;
      }
    }
    return BudgetLimits(monthly: monthlyLimit, byCategory: byCategory);
  }

  static double? _decode(String value) {
    final limit = double.tryParse(value);
    return limit != null && limit.isFinite && limit > 0 ? limit : null;
  }
}
