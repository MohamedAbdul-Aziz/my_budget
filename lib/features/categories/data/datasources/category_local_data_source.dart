import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense_category.dart';
import '../models/category_model.dart';

abstract interface class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<CategoryModel> insertCategory(CategoryModel category);

  Future<CategoryModel> updateCategory(CategoryModel category);

  /// Returns how many expenses were moved to the fallback category.
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
        orderBy: 'sort_order ASC, name COLLATE NOCASE ASC',
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
        // Re-home the expenses first, so nothing is ever silently dropped
        // along with the category. Each move is a change of its own that the
        // next backup carries to the cloud.
        final moved = await txn.update(
          'expenses',
          AppDatabase.changed({'category_id': ExpenseCategory.fallbackId}),
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
