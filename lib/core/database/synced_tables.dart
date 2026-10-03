import '../../features/categories/domain/entities/expense_category.dart';
import '../../features/categories/domain/entities/transaction_type.dart';
import '../../features/people/domain/entities/person_transaction_type.dart';
import '../../features/recurring/domain/entities/recurrence_frequency.dart';
import '../../features/recurring/domain/entities/recurring_mode.dart';

/// Every table of user data that leaves the phone, in the order it is
/// written: parents before the rows that point at them.
///
/// The cloud sync, the backup file and the merge and replace rules all work
/// from this list, so a feature's new table travels everywhere once it is
/// added here (and to `AppDatabase` and a Supabase migration; the tests in
/// `test/data/synced_tables_test.dart` check all three agree).
///
/// A table's portable form, the one in the Supabase table and the backup
/// file, is its columns minus the phone's `dirty` flag. Only a [flag]
/// changes form on the way out: 0/1 on the phone, a boolean elsewhere.
abstract final class SyncedTables {
  static final SyncedTable categories = SyncedTable(
    'categories',
    orderBy: 'sort_order, id',
    // Transactions and schedules fall back to these; they are never deleted.
    keepIds: const {
      ExpenseCategory.fallbackId,
      ExpenseCategory.incomeFallbackId,
    },
    columns: [
      const SyncedColumn.text('id'),
      const SyncedColumn.text('name'),
      const SyncedColumn.text('icon_name'),
      const SyncedColumn.integer('color_value'),
      // Absent from files made before income existed: those are spending.
      SyncedColumn.choice(
        'type',
        [for (final type in TransactionType.values) type.storageKey],
        fallback: TransactionType.expense.storageKey,
        optional: true,
      ),
      const SyncedColumn.flag('is_default'),
      const SyncedColumn.integer('sort_order'),
    ],
  );

  /// Spending and income alike: a transaction is its category's type.
  static final SyncedTable expenses = SyncedTable(
    'expenses',
    orderBy: 'date, created_at, id',
    categoryColumn: 'category_id',
    columns: const [
      SyncedColumn.text('id'),
      SyncedColumn.money('amount'),
      SyncedColumn.text('description', optional: true),
      SyncedColumn.text('category_id'),
      SyncedColumn.integer('date'),
      // Stored rather than recomputed: the month is decided in the timezone
      // of the phone that recorded the transaction.
      SyncedColumn.text('month_key', pattern: r'^\d{4}-\d{2}$'),
      SyncedColumn.integer('created_at'),
    ],
  );

  /// App preferences and budgets (`budget.*`). A removed value is an empty
  /// one, so the table has no deleted marker.
  static final SyncedTable settings = SyncedTable(
    'settings',
    key: 'key',
    orderBy: 'key',
    softDelete: false,
    columns: const [
      SyncedColumn.text('key'),
      SyncedColumn.text('value', allowEmpty: true),
    ],
  );

  /// Due dates are calendar days, `yyyy-MM-dd`: text on the phone and in the
  /// file, a `date` column in the cloud, which reads and writes the same text.
  static final SyncedTable recurring = SyncedTable(
    'recurring_expenses',
    orderBy: 'created_at, id',
    since: 3,
    categoryColumn: 'category_id',
    columns: [
      const SyncedColumn.text('id'),
      const SyncedColumn.text('title'),
      const SyncedColumn.money('amount'),
      const SyncedColumn.text('category_id'),
      SyncedColumn.choice('frequency', [
        for (final frequency in RecurrenceFrequency.values)
          frequency.storageKey,
      ], fallback: RecurrenceFrequency.monthly.storageKey),
      const SyncedColumn.integer('due_day', min: 1, max: 31),
      const SyncedColumn.integer('due_month', optional: true, min: 1, max: 12),
      SyncedColumn.choice('mode', [
        for (final mode in RecurringMode.values) mode.storageKey,
      ], fallback: RecurringMode.reminder.storageKey),
      const SyncedColumn.day('starts_on'),
      const SyncedColumn.day('paid_through', optional: true),
      const SyncedColumn.integer('created_at'),
    ],
    check: (json) =>
        json['frequency'] == RecurrenceFrequency.yearly.storageKey &&
            json['due_month'] == null
        ? 'due_month'
        : null,
  );

  static final SyncedTable people = SyncedTable(
    'people',
    orderBy: 'created_at, id',
    since: 4,
    columns: const [
      SyncedColumn.text('id'),
      SyncedColumn.text('name'),
      SyncedColumn.text('phone', optional: true),
      SyncedColumn.integer('color_value'),
      SyncedColumn.integer('created_at'),
    ],
  );

  /// `net_amount` is the balance a settle-up cleared: positive when the
  /// person paid the user back, negative when the user paid them.
  /// `expense_id` is a plain reference: the budget transaction can be
  /// deleted on its own.
  static final SyncedTable settlements = SyncedTable(
    'settlements',
    orderBy: 'settled_at, id',
    since: 4,
    parent: (column: 'person_id', table: 'people'),
    columns: const [
      SyncedColumn.text('id'),
      SyncedColumn.text('person_id'),
      SyncedColumn.money('net_amount', signed: true),
      SyncedColumn.integer('settled_at'),
      SyncedColumn.text('expense_id', optional: true),
      SyncedColumn.integer('created_at'),
    ],
  );

  /// Open until `settled_at` is set, with the `settlement_id` (a plain
  /// reference) of the settle-up that cleared it.
  static final SyncedTable personTransactions = SyncedTable(
    'person_transactions',
    orderBy: 'date, created_at, id',
    since: 4,
    parent: (column: 'person_id', table: 'people'),
    columns: [
      const SyncedColumn.text('id'),
      const SyncedColumn.text('person_id'),
      ..._debtColumns,
      const SyncedColumn.integer('settled_at', optional: true),
      const SyncedColumn.text('settlement_id', optional: true),
      const SyncedColumn.integer('created_at'),
    ],
  );

  /// The values a transaction had just before each edit.
  static final SyncedTable personTransactionEdits = SyncedTable(
    'person_transaction_edits',
    orderBy: 'edited_at, id',
    since: 4,
    parent: (column: 'transaction_id', table: 'person_transactions'),
    columns: [
      const SyncedColumn.text('id'),
      const SyncedColumn.text('transaction_id'),
      ..._debtColumns,
      const SyncedColumn.integer('edited_at'),
    ],
  );

  static final List<SyncedColumn> _debtColumns = [
    const SyncedColumn.money('amount'),
    SyncedColumn.choice('type', [
      for (final type in PersonTransactionType.values) type.storageKey,
    ], fallback: PersonTransactionType.iPaidForThem.storageKey),
    const SyncedColumn.text('note', optional: true),
    const SyncedColumn.integer('date'),
  ];

  static final List<SyncedTable> all = [
    categories,
    expenses,
    settings,
    recurring,
    people,
    settlements,
    personTransactions,
    personTransactionEdits,
  ];

  /// The rows elsewhere that point at [table]'s rows: a deleted row can only
  /// be removed for good once none of them does.
  static List<({String table, String column})> referrersOf(SyncedTable table) =>
      [
        for (final other in all) ...[
          if (table == categories && other.categoryColumn != null)
            (table: other.name, column: other.categoryColumn!),
          if (other.parent?.table == table.name)
            (table: other.name, column: other.parent!.column),
        ],
      ];
}

/// One table of [SyncedTables].
final class SyncedTable {
  SyncedTable(
    this.name, {
    this.key = 'id',
    required List<SyncedColumn> columns,
    required this.orderBy,
    this.softDelete = true,
    this.since = 1,
    this.categoryColumn,
    this.parent,
    this.keepIds = const {},
    this.check,
  }) : columns = [
         ...columns,
         const SyncedColumn.integer('updated_at'),
         if (softDelete)
           const SyncedColumn.integer('deleted_at', optional: true),
       ];

  /// Its name on the phone, in the cloud, and in a backup file.
  final String name;

  /// What identifies a row.
  final String key;

  /// Every column that travels, sync bookkeeping included.
  final List<SyncedColumn> columns;

  /// How rows are ordered when they are all read, which is the order a
  /// backup file lists them in.
  final String orderBy;

  /// Whether a delete is kept as a row with `deleted_at` set, so that it can
  /// travel too. Every table except `settings`.
  final bool softDelete;

  /// The backup file format version that added the table. Older files have
  /// none of its rows.
  final int since;

  /// Rows keep a category. One that exists nowhere could only come from a
  /// damaged copy, and the row moves to Other; a deleted one moves the row
  /// to Other or Other income, as deleting it on the phone would.
  final String? categoryColumn;

  /// Rows belong to a row of another table. One whose parent exists nowhere
  /// is skipped, and a parent's delete takes its rows with it.
  final ({String column, String table})? parent;

  /// Rows that are never deleted, even by a replace.
  final Set<String> keepIds;

  /// A rule across columns, beyond what each column checks for itself.
  /// Returns the name of the field that breaks it.
  final String? Function(Map<String, dynamic> json)? check;

  /// [row] from the phone, in portable form.
  Map<String, Object?> toPortable(Map<String, Object?> row) => {
    for (final column in columns)
      column.name: column.toPortable(row[column.name]),
  };

  /// A portable row, in the phone's form. Numbers come back as the types
  /// SQLite stores, and a value this version does not know is read the way
  /// the app reads it.
  Map<String, Object?> fromPortable(Map<String, dynamic> json) => {
    for (final column in columns)
      column.name: column.fromPortable(json[column.name]),
  };

  /// The first field of a portable row this version cannot accept, or null.
  String? problemIn(Map<String, dynamic> json) {
    for (final column in columns) {
      if (!column.accepts(json[column.name])) return column.name;
    }
    return check?.call(json);
  }
}

/// What a column holds: how it travels, and what a backup file may put in
/// it. The Supabase checks mirror these rules and must never be stricter.
final class SyncedColumn {
  /// A string; empty only when [optional] or [allowEmpty].
  const SyncedColumn.text(
    this.name, {
    this.optional = false,
    this.allowEmpty = false,
    this.pattern,
  }) : _kind = _Kind.text,
       min = null,
       max = null,
       signed = false,
       choices = const [],
       fallback = null;

  const SyncedColumn.integer(
    this.name, {
    this.optional = false,
    this.min,
    this.max,
  }) : _kind = _Kind.integer,
       allowEmpty = false,
       pattern = null,
       signed = false,
       choices = const [],
       fallback = null;

  /// A finite amount, more than zero unless [signed].
  const SyncedColumn.money(this.name, {this.signed = false})
    : _kind = _Kind.money,
      optional = false,
      allowEmpty = false,
      pattern = null,
      min = null,
      max = null,
      choices = const [],
      fallback = null;

  /// 0/1 on the phone, a boolean anywhere else.
  const SyncedColumn.flag(this.name)
    : _kind = _Kind.flag,
      optional = false,
      allowEmpty = false,
      pattern = null,
      min = null,
      max = null,
      signed = false,
      choices = const [],
      fallback = null;

  /// One of [choices]. A backup file must hold one of them; anything else
  /// arriving from the cloud, which a newer app version could have written,
  /// is read as [fallback], the way the app reads it.
  const SyncedColumn.choice(
    this.name,
    this.choices, {
    required String this.fallback,
    this.optional = false,
  }) : _kind = _Kind.choice,
       allowEmpty = false,
       pattern = null,
       min = null,
       max = null,
       signed = false;

  /// A calendar day, `yyyy-MM-dd`.
  const SyncedColumn.day(this.name, {this.optional = false})
    : _kind = _Kind.day,
      allowEmpty = false,
      pattern = null,
      min = null,
      max = null,
      signed = false,
      choices = const [],
      fallback = null;

  final String name;
  final _Kind _kind;

  /// May be null.
  final bool optional;
  final bool allowEmpty;
  final String? pattern;
  final int? min;
  final int? max;
  final bool signed;
  final List<String> choices;
  final String? fallback;

  static final RegExp _day = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  Object? toPortable(Object? value) => switch (_kind) {
    _Kind.flag => value == 1,
    _Kind.choice => value ?? fallback,
    _ => value,
  };

  Object? fromPortable(Object? value) => switch (_kind) {
    _Kind.integer => (value as num?)?.toInt(),
    _Kind.money => (value! as num).toDouble(),
    _Kind.flag => value == true ? 1 : 0,
    _Kind.choice => choices.contains(value) ? value : fallback,
    _Kind.text || _Kind.day => value,
  };

  bool accepts(Object? value) {
    if (value == null) return optional;
    return switch (_kind) {
      _Kind.text =>
        value is String &&
            (optional || allowEmpty || value.isNotEmpty) &&
            (pattern == null || RegExp(pattern!).hasMatch(value)),
      _Kind.integer =>
        value is int &&
            (min == null || value >= min!) &&
            (max == null || value <= max!),
      _Kind.money => value is num && value.isFinite && (signed || value > 0),
      _Kind.flag => value is bool,
      _Kind.choice => choices.contains(value),
      _Kind.day =>
        value is String &&
            _day.hasMatch(value) &&
            DateTime.tryParse(value) != null,
    };
  }
}

enum _Kind { text, integer, money, flag, choice, day }
