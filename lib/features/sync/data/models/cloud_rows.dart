/// Converts rows between the phone's SQLite columns and the Supabase tables.
///
/// The two match column for column, except that the cloud adds `user_id` and
/// stores `is_default` as a boolean rather than 0/1. The phone's `dirty` flag
/// never leaves the phone.
abstract final class CloudRows {
  static Map<String, Object?> categoryToCloud(
    Map<String, Object?> row,
    String userId,
  ) => {
    'user_id': userId,
    'id': row['id'],
    'name': row['name'],
    'icon_name': row['icon_name'],
    'color_value': row['color_value'],
    'is_default': row['is_default'] == 1,
    'sort_order': row['sort_order'],
    'updated_at': row['updated_at'],
    'deleted_at': row['deleted_at'],
  };

  static Map<String, Object?> categoryFromCloud(Map<String, dynamic> json) => {
    'id': json['id'],
    'name': json['name'],
    'icon_name': json['icon_name'],
    'color_value': (json['color_value'] as num).toInt(),
    'is_default': json['is_default'] == true ? 1 : 0,
    'sort_order': (json['sort_order'] as num).toInt(),
    'updated_at': (json['updated_at'] as num).toInt(),
    'deleted_at': (json['deleted_at'] as num?)?.toInt(),
  };

  static Map<String, Object?> expenseToCloud(
    Map<String, Object?> row,
    String userId,
  ) => {
    'user_id': userId,
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

  static Map<String, Object?> expenseFromCloud(Map<String, dynamic> json) => {
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

  static Map<String, Object?> settingToCloud(
    Map<String, Object?> row,
    String userId,
  ) => {
    'user_id': userId,
    'key': row['key'],
    'value': row['value'],
    'updated_at': row['updated_at'],
  };

  static Map<String, Object?> settingFromCloud(Map<String, dynamic> json) => {
    'key': json['key'],
    'value': json['value'],
    'updated_at': (json['updated_at'] as num).toInt(),
  };
}
