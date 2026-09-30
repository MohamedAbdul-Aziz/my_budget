import '../../../categories/data/models/category_model.dart';
import '../../domain/entities/recurrence_frequency.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/entities/recurring_mode.dart';

/// Maps a `recurring_expenses` row, joined with its category, to the domain
/// entity and back.
class RecurringExpenseModel extends RecurringExpense {
  const RecurringExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.frequency,
    required super.dueDay,
    super.dueMonth,
    required super.mode,
    required super.startsOn,
    super.paidThrough,
    required super.createdAt,
  });

  /// Expects the aliased columns produced by [selectJoin].
  factory RecurringExpenseModel.fromJoinedMap(Map<String, Object?> map) {
    final paidThrough = map['paid_through'] as String?;
    return RecurringExpenseModel(
      id: map['id']! as String,
      title: map['title']! as String,
      amount: (map['amount']! as num).toDouble(),
      frequency: RecurrenceFrequency.fromStorageKey(map['frequency']),
      dueDay: (map['due_day']! as num).toInt(),
      dueMonth: (map['due_month'] as num?)?.toInt(),
      mode: RecurringMode.fromStorageKey(map['mode']),
      startsOn: parseDay(map['starts_on']! as String),
      paidThrough: paidThrough == null ? null : parseDay(paidThrough),
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
        'type': map['category_type'],
      }),
    );
  }

  /// The single join used by every read, so rows always parse the same way.
  static const String selectJoin = '''
    SELECT
      r.id            AS id,
      r.title         AS title,
      r.amount        AS amount,
      r.frequency     AS frequency,
      r.due_day       AS due_day,
      r.due_month     AS due_month,
      r.mode          AS mode,
      r.starts_on     AS starts_on,
      r.paid_through  AS paid_through,
      r.created_at    AS created_at,
      c.id            AS category_id,
      c.name          AS category_name,
      c.icon_name     AS category_icon_name,
      c.color_value   AS category_color_value,
      c.is_default    AS category_is_default,
      c.sort_order    AS category_sort_order,
      c.type          AS category_type
    FROM recurring_expenses r
    INNER JOIN categories c ON c.id = r.category_id
  ''';

  static Map<String, Object?> toRow(RecurringExpense recurring) {
    final paidThrough = recurring.paidThrough;
    return {
      'id': recurring.id,
      'title': recurring.title,
      'amount': recurring.amount,
      'category_id': recurring.category.id,
      'frequency': recurring.frequency.storageKey,
      'due_day': recurring.dueDay,
      'due_month': recurring.dueMonth,
      'mode': recurring.mode.storageKey,
      'starts_on': dayKey(recurring.startsOn),
      'paid_through': paidThrough == null ? null : dayKey(paidThrough),
      'created_at': recurring.createdAt.millisecondsSinceEpoch,
    };
  }

  /// The transaction logged for the payment due on [due]. The same on every
  /// phone, so two phones logging the same payment make one transaction once
  /// they sync, not two.
  static String expenseIdFor(String recurringId, DateTime due) =>
      '${recurringId}_${dayKey(due).replaceAll('-', '')}';

  /// `2026-09-30`: sorts as text in date order.
  static String dayKey(DateTime day) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${day.year.toString().padLeft(4, '0')}-'
        '${two(day.month)}-${two(day.day)}';
  }

  static DateTime parseDay(String key) {
    final parsed = DateTime.parse(key);
    return DateTime(parsed.year, parsed.month, parsed.day);
  }
}
