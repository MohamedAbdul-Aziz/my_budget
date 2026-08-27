import '../../../categories/data/models/category_model.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/month.dart';

/// Maps an `expenses` row — joined with its category — to the domain entity.
class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.amount,
    required super.category,
    required super.date,
    required super.createdAt,
    super.description,
  });

  /// Expects the aliased columns produced by [selectJoin].
  factory ExpenseModel.fromJoinedMap(Map<String, Object?> map) => ExpenseModel(
    id: map['id']! as String,
    amount: (map['amount']! as num).toDouble(),
    description: map['description'] as String?,
    date: DateTime.fromMillisecondsSinceEpoch((map['date']! as num).toInt()),
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      (map['created_at']! as num).toInt(),
    ),
    category: CategoryModel.fromMap({
      'id': map['category_id'],
      'name': map['category_name'],
      'icon_name': map['category_icon_name'],
      'color_value': map['category_color_value'],
      'is_default': map['category_is_default'],
      'sort_order': map['category_sort_order'],
    }),
  );

  /// The single join used by every read, so rows always parse the same way.
  static const String selectJoin = '''
    SELECT
      e.id            AS id,
      e.amount        AS amount,
      e.description   AS description,
      e.date          AS date,
      e.created_at    AS created_at,
      c.id            AS category_id,
      c.name          AS category_name,
      c.icon_name     AS category_icon_name,
      c.color_value   AS category_color_value,
      c.is_default    AS category_is_default,
      c.sort_order    AS category_sort_order
    FROM expenses e
    INNER JOIN categories c ON c.id = e.category_id
  ''';

  static Map<String, Object?> toRow({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    required DateTime createdAt,
    String? description,
  }) => {
    'id': id,
    'amount': amount,
    'description': description,
    'category_id': categoryId,
    'date': date.millisecondsSinceEpoch,
    'month_key': Month.fromDate(date).key,
    'created_at': createdAt.millisecondsSinceEpoch,
  };
}
