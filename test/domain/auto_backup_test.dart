import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/sync/domain/usecases/auto_back_up.dart';

import '../presentation/fakes.dart';

void main() {
  late FakeSyncRepository sync;
  late FakeAuthRepository auth;
  late AutoBackUp autoBackUp;

  setUp(() {
    sync = FakeSyncRepository()..autoBackup = true;
    auth = FakeAuthRepository()..openConfirmationLink('mohamed@example.com');
    autoBackUp = AutoBackUp(syncRepository: sync, authRepository: auth);
  });

  test(
    'backs up what changed when it is on and someone is signed in',
    () async {
      final result = await autoBackUp();

      expect(result.dataOrNull, isNotNull);
      expect(sync.backUps, 1);
    },
  );

  test('does nothing while it is off, as on a new phone', () async {
    sync.autoBackup = false;

    final result = await autoBackUp();

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, isNull);
    expect(sync.backUps, 0);
  });

  test('does nothing when nobody is signed in', () async {
    auth.currentUser = null;

    expect((await autoBackUp()).dataOrNull, isNull);
    expect(sync.backUps, 0);
  });

  test('does not touch the network when nothing changed', () async {
    sync.pending = false;

    expect((await autoBackUp()).dataOrNull, isNull);
    expect(sync.backUps, 0);
  });

  test('reports a failed upload', () async {
    sync.failWith = const NetworkFailure('offline');

    final result = await autoBackUp();

    expect(result.failureOrNull?.code, FailureCode.network);
  });
}
