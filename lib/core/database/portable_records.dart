import '../../features/people/domain/entities/person_transaction_type.dart';

/// Converts rows between the phone's SQLite columns and the portable form
/// that leaves the phone: the Supabase tables and the backup file.
///
/// The two match column for column, except that the portable form stores
/// `is_default` as a boolean rather than 0/1. A category from before income
/// existed has no `type`, and is spending. The people and debts tables
/// travel exactly as stored. The phone's `dirty` flag never
/// leaves the phone. The cloud adds its own `user_id` on top.
abstract final class PortableRecords {
  static Map<String, Object?> categoryToPortable(Map<String, Object?> row) => {
    'id': row['id'],
    'name': row['name'],
    'icon_name': row['icon_name'],
    'color_value': row['color_value'],
    'type': row['type'] ?? 'expense',
    'is_default': row['is_default'] == 1,
    'sort_order': row['sort_order'],
    'updated_at': row['updated_at'],
    'deleted_at': row['deleted_at'],
  };

  static Map<String, Object?> categoryFromPortable(Map<String, dynamic> json) =>
      {
        'id': json['id'],
        'name': json['name'],
        'icon_name': json['icon_name'],
        'color_value': (json['color_value'] as num).toInt(),
        'type': json['type'] == 'income' ? 'income' : 'expense',
        'is_default': json['is_default'] == true ? 1 : 0,
        'sort_order': (json['sort_order'] as num).toInt(),
        'updated_at': (json['updated_at'] as num).toInt(),
        'deleted_at': (json['deleted_at'] as num?)?.toInt(),
      };

  static Map<String, Object?> expenseToPortable(Map<String, Object?> row) => {
    'id': row['id'],
    'amount': row['amount'],
    'description': row['description'],
    'category_id': row['category_id'],
    'date': row['date'],
    'month_key': row['month_key'],
    'created_at': row['created_at'],
    'updated_at': row['updated_at'],
    'deleted_at': row['deleted_at'],
  };

  static Map<String, Object?> expenseFromPortable(
    Map<String, dynamic> json,
  ) => {
    'id': json['id'],
    'amount': (json['amount'] as num).toDouble(),
    'description': json['description'],
    'category_id': json['category_id'],
    'date': (json['date'] as num).toInt(),
    // Stored rather than recomputed: the month is decided in the timezone of
    // the phone that recorded the expense.
    'month_key': json['month_key'],
    'created_at': (json['created_at'] as num).toInt(),
    'updated_at': (json['updated_at'] as num).toInt(),
    'deleted_at': (json['deleted_at'] as num?)?.toInt(),
  };

  /// Due dates are `yyyy-MM-dd` text on the phone and in the file, and a
  /// `date` column in the cloud, which reads and writes the same text.
  static Map<String, Object?> recurringToPortable(Map<String, Object?> row) => {
    'id': row['id'],
    'title': row['title'],
    'amount': row['amount'],
    'category_id': row['category_id'],
    'frequency': row['frequency'],
    'due_day': row['due_day'],
    'due_month': row['due_month'],
    'mode': row['mode'],
    'starts_on': row['starts_on'],
    'paid_through': row['paid_through'],
    'created_at': row['created_at'],
    'updated_at': row['updated_at'],
    'deleted_at': row['deleted_at'],
  };

  /// Anything unknown in `frequency` or `mode` falls back the way the app
  /// reads it: monthly, and a reminder rather than an automatic payment.
  static Map<String, Object?> recurringFromPortable(
    Map<String, dynamic> json,
  ) => {
    'id': json['id'],
    'title': json['title'],
    'amount': (json['amount'] as num).toDouble(),
    'category_id': json['category_id'],
    'frequency': switch (json['frequency']) {
      'weekly' || 'yearly' => json['frequency'],
      _ => 'monthly',
    },
    'due_day': (json['due_day'] as num).toInt(),
    'due_month': (json['due_month'] as num?)?.toInt(),
    'mode': json['mode'] == 'auto' ? 'auto' : 'reminder',
    'starts_on': json['starts_on'],
    'paid_through': json['paid_through'],
    'created_at': (json['created_at'] as num).toInt(),
    'updated_at': (json['updated_at'] as num).toInt(),
    'deleted_at': (json['deleted_at'] as num?)?.toInt(),
  };

  /// The people and debts tables have no column that changes form on the
  /// way out, so each table's portable form is its columns minus `dirty`.
  static const Map<String, List<String>> peopleColumns = {
    'people': [
      'id',
      'name',
      'phone',
      'color_value',
      'created_at',
      'updated_at',
      'deleted_at',
    ],
    'settlements': [
      'id',
      'person_id',
      'net_amount',
      'settled_at',
      'expense_id',
      'created_at',
      'updated_at',
      'deleted_at',
    ],
    'person_transactions': [
      'id',
      'person_id',
      'amount',
      'type',
      'note',
      'date',
      'settled_at',
      'settlement_id',
      'created_at',
      'updated_at',
      'deleted_at',
    ],
    'person_transaction_edits': [
      'id',
      'transaction_id',
      'amount',
      'type',
      'note',
      'date',
      'edited_at',
      'updated_at',
      'deleted_at',
    ],
  };

  static const Set<String> _moneyColumns = {'amount', 'net_amount'};
  static const Set<String> _intColumns = {
    'color_value',
    'created_at',
    'updated_at',
    'deleted_at',
    'settled_at',
    'date',
    'edited_at',
  };

  /// A row of one of the [peopleColumns] tables, in portable form.
  static Map<String, Object?> toPortable(
    String table,
    Map<String, Object?> row,
  ) => {for (final column in peopleColumns[table]!) column: row[column]};

  /// A portable row of one of the [peopleColumns] tables, in the phone's
  /// form. Numbers come back as the types SQLite stores, and a transaction
  /// type this version does not know is read the way the app reads it.
  static Map<String, Object?> fromPortable(
    String table,
    Map<String, dynamic> json,
  ) => {
    for (final column in peopleColumns[table]!)
      column: switch (column) {
        'type' => PersonTransactionType.fromStorageKey(json[column]).storageKey,
        _ when _moneyColumns.contains(column) =>
          (json[column] as num).toDouble(),
        _ when _intColumns.contains(column) => (json[column] as num?)?.toInt(),
        _ => json[column],
      },
  };

  static Map<String, Object?> settingToPortable(Map<String, Object?> row) => {
    'key': row['key'],
    'value': row['value'],
    'updated_at': row['updated_at'],
  };

  static Map<String, Object?> settingFromPortable(Map<String, dynamic> json) =>
      {
        'key': json['key'],
        'value': json['value'],
        'updated_at': (json['updated_at'] as num).toInt(),
      };
}
