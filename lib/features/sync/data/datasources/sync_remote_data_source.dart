import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/database/portable_records.dart';
import '../../../../core/database/record_batch.dart';

abstract interface class SyncRemoteDataSource {
  /// The signed-in user, or null.
  String? get currentUserId;

  /// Upserts [batch] into the user's cloud tables. [onUploaded] is told how
  /// many rows each request carried.
  Future<void> upload(
    RecordBatch batch, {
    required String userId,
    void Function(int count)? onUploaded,
  });

  /// Every cloud row the signed-in user owns, deleted ones included so that
  /// deletes reach the phone. [onProgress] runs after each table.
  Future<RecordBatch> download({void Function(double fraction)? onProgress});
}

/// The Supabase tables mirror the phone's SQLite tables column for column,
/// plus `user_id`. Row level security limits every request to the signed-in
/// user's rows, and a trigger in the database skips any upsert older than
/// the row it would replace, so newest-wins holds whichever phone uploads.
class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  const SyncRemoteDataSourceImpl(this._client);

  /// Rows per upsert request, to keep request bodies small.
  static const int _uploadChunk = 500;

  /// Rows per read request. Paging continues until a page comes back empty,
  /// so a smaller server-side row cap only costs extra requests.
  static const int _downloadPage = 1000;

  final SupabaseClient _client;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<void> upload(
    RecordBatch batch, {
    required String userId,
    void Function(int count)? onUploaded,
  }) => _guard(() async {
    // Categories go first so the cloud never holds an expense whose category
    // has not arrived yet.
    await _upsert('categories', 'user_id,id', [
      for (final row in batch.categories)
        {'user_id': userId, ...PortableRecords.categoryToPortable(row)},
    ], onUploaded);
    await _upsert('expenses', 'user_id,id', [
      for (final row in batch.expenses)
        {'user_id': userId, ...PortableRecords.expenseToPortable(row)},
    ], onUploaded);
    await _upsert('user_settings', 'user_id,key', [
      for (final row in batch.settings)
        {'user_id': userId, ...PortableRecords.settingToPortable(row)},
    ], onUploaded);
    await _upsert('recurring_expenses', 'user_id,id', [
      for (final row in batch.recurring)
        {'user_id': userId, ...PortableRecords.recurringToPortable(row)},
    ], onUploaded);
    // People before what was recorded with them.
    for (final MapEntry(key: table, value: rows)
        in batch.peopleTables.entries) {
      await _upsert(table, 'user_id,id', [
        for (final row in rows)
          {'user_id': userId, ...PortableRecords.toPortable(table, row)},
      ], onUploaded);
    }
  });

  @override
  Future<RecordBatch> download({void Function(double fraction)? onProgress}) =>
      _guard(() async {
        const tables = 8;
        var done = 0;
        Future<List<Map<String, Object?>>> read(
          String table,
          String key,
          Map<String, Object?> Function(Map<String, dynamic>) fromPortable,
        ) async {
          final rows = await _readAll(table, key);
          onProgress?.call(++done / tables);
          return rows.map(fromPortable).toList();
        }

        Future<List<Map<String, Object?>>> readPeople(String table) => read(
          table,
          'id',
          (json) => PortableRecords.fromPortable(table, json),
        );

        return RecordBatch(
          categories: await read(
            'categories',
            'id',
            PortableRecords.categoryFromPortable,
          ),
          expenses: await read(
            'expenses',
            'id',
            PortableRecords.expenseFromPortable,
          ),
          settings: await read(
            'user_settings',
            'key',
            PortableRecords.settingFromPortable,
          ),
          recurring: await read(
            'recurring_expenses',
            'id',
            PortableRecords.recurringFromPortable,
          ),
          people: await readPeople('people'),
          settlements: await readPeople('settlements'),
          personTransactions: await readPeople('person_transactions'),
          personTransactionEdits: await readPeople('person_transaction_edits'),
        );
      });

  Future<void> _upsert(
    String table,
    String onConflict,
    List<Map<String, Object?>> rows,
    void Function(int count)? onUploaded,
  ) async {
    for (var start = 0; start < rows.length; start += _uploadChunk) {
      final end = start + _uploadChunk < rows.length
          ? start + _uploadChunk
          : rows.length;
      final chunk = rows.sublist(start, end);
      await _client.from(table).upsert(chunk, onConflict: onConflict);
      onUploaded?.call(chunk.length);
    }
  }

  Future<List<Map<String, dynamic>>> _readAll(String table, String key) async {
    final rows = <Map<String, dynamic>>[];
    while (true) {
      final page = await _client
          .from(table)
          .select()
          .order(key)
          .range(rows.length, rows.length + _downloadPage - 1);
      if (page.isEmpty) return rows;
      rows.addAll(page);
    }
  }

  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SocketException catch (error) {
      throw NetworkFailure('$error');
    } on http.ClientException catch (error) {
      throw NetworkFailure('$error');
    } on TimeoutException catch (error) {
      throw NetworkFailure('$error');
    } on AuthRetryableFetchException catch (error) {
      // Refreshing the session before the request needed the network.
      throw NetworkFailure(error.message);
    } on AuthException catch (error) {
      throw SyncFailure(FailureCode.signInRequired, error.message);
    } on PostgrestException catch (error) {
      // PGRST301: the session token expired and could not be refreshed.
      throw SyncFailure(
        error.code == 'PGRST301'
            ? FailureCode.signInRequired
            : FailureCode.syncFailed,
        '${error.code}: ${error.message}',
      );
    }
  }
}
