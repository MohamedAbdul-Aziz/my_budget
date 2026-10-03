import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/transaction_type.dart';
import '../models/category_model.dart';

abstract interface class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<CategoryModel> insertCategory(CategoryModel category);

  Future<CategoryModel> updateCategory(CategoryModel category);

  /// Returns how many transactions were moved to the fallback category of
  /// the same type.
  Future<int> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  const CategoryLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(
        'categories',
        where: 'deleted_at IS NULL',
        // Spending categories first ('expense' sorts before 'income'), each
        // type in the user's order.
        orderBy: 'type ASC, sort_order ASC, name COLLATE NOCASE ASC',
      );
      return rows.map(CategoryModel.fromMap).toList();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load categories: $error');
    }
  }

  @override
  Future<CategoryModel> insertCategory(CategoryModel category) async {
    try {
      final db = await _appDatabase.database;
      await db.insert(
        'categories',
        AppDatabase.changed(category.toMap()),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return category;
    } on DatabaseException catch (error) {
      throw DatabaseFailure('insert category: $error');
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      final db = await _appDatabase.database;
      final count = await db.update(
        'categories',
        AppDatabase.changed(category.toMap()),
        where: 'id = ? AND deleted_at IS NULL',
        whereArgs: [category.id],
      );
      if (count == 0) {
        throw const NotFoundFailure('category missing');
      }
      return category;
    } on DatabaseException catch (error) {
      throw DatabaseFailure('update category: $error');
    }
  }

  @override
  Future<int> deleteCategory(String id) async {
    try {
      final db = await _appDatabase.database;
      return db.transaction((txn) async {
        final rows = await txn.query(
          'categories',
          columns: ['type'],
          where: 'id = ? AND deleted_at IS NULL',
          whereArgs: [id],
          limit: 1,
        );
        if (rows.isEmpty) {
          throw const NotFoundFailure('category missing');
        }
        // Spending moves to Other and income to Other income, so a delete
        // never turns one into the other.
        final fallbackId = ExpenseCategory.fallbackIdFor(
          TransactionType.fromStorageKey(rows.first['type']),
        );

        // Re-home the transactions first, so nothing is ever silently
        // dropped along with the category. Each move is a change of its own
        // that the next backup carries to the cloud.
        final moved = await txn.update(
          'expenses',
          AppDatabase.changed({'category_id': fallbackId}),
          where: 'category_id = ? AND deleted_at IS NULL',
          whereArgs: [id],
        );
        // Recurring payments follow, so the ones they log land there too.
        await txn.update(
          'recurring_expenses',
          AppDatabase.changed({'category_id': fallbackId}),
          where: 'category_id = ? AND deleted_at IS NULL',
          whereArgs: [id],
        );
        // Kept as a marked row rather than deleted, so the delete can sync.
        final now = AppDatabase.nowMillis();
        final deleted = await txn.update(
          'categories',
          {'deleted_at': now, 'updated_at': now, 'dirty': 1},
          where: 'id = ? AND deleted_at IS NULL',
          whereArgs: [id],
        );
        if (deleted == 0) {
          throw const NotFoundFailure('category missing');
        }
        return moved;
      });
    } on DatabaseException catch (error) {
      throw DatabaseFailure('delete category: $error');
    }
  }
}
