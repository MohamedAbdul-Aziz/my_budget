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
        category.toMap(),
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
        category.toMap(),
        where: 'id = ?',
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
        // Re-home the expenses first: the FK is ON DELETE RESTRICT, so nothing
        // is ever silently dropped along with the category.
        final moved = await txn.update(
          'expenses',
          {'category_id': ExpenseCategory.fallbackId},
          where: 'category_id = ?',
          whereArgs: [id],
        );
        final deleted = await txn.delete(
          'categories',
          where: 'id = ?',
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
