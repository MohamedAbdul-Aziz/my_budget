import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/database/record_batch.dart';
import '../../../../core/database/synced_tables.dart';

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

/// Every table in [SyncedTables] has a Supabase table of the same name that
/// mirrors it column for column, plus `user_id`. Row level security limits
/// every request to the signed-in user's rows, and a trigger in the database
/// skips any upsert older than the row it would replace, so newest-wins holds
/// whichever phone uploads.
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

  /// Parents first, so the cloud never holds a row whose parent has not
  /// arrived yet.
  @override
  Future<void> upload(
    RecordBatch batch, {
    required String userId,
    void Function(int count)? onUploaded,
  }) => _guard(() async {
    for (final table in SyncedTables.all) {
      await _upsert(table.name, 'user_id,${table.key}', [
        for (final row in batch[table])
          {'user_id': userId, ...table.toPortable(row)},
      ], onUploaded);
    }
  });

  @override
  Future<RecordBatch> download({void Function(double fraction)? onProgress}) =>
      _guard(() async {
        final tables = SyncedTables.all;
        final rows = <String, List<Map<String, Object?>>>{};
        for (final table in tables) {
          rows[table.name] = [
            for (final json in await _readAll(table.name, table.key))
              table.fromPortable(json),
          ];
          onProgress?.call(rows.length / tables.length);
        }
        return RecordBatch(rows);
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
