import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/app_lock/domain/entities/app_lock_prompt.dart';
import 'package:my_budget/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:my_budget/features/app_lock/domain/usecases/get_app_lock.dart';
import 'package:my_budget/features/app_lock/domain/usecases/set_app_lock.dart';
import 'package:my_budget/features/app_lock/domain/usecases/unlock_app.dart';

import '../presentation/fakes.dart';

const _prompt = AppLockPrompt(reason: 'Why', title: 'Title', cancel: 'Cancel');

void main() {
  late FakeAppLockRepository repository;

  setUp(() => repository = FakeAppLockRepository());

  test('reads what the phone offers and what the user chose', () async {
    repository.enabled = true;

    expect(
      (await GetAppLock(repository)()).dataOrNull,
      const AppLockStatus(supported: true, available: true, enabled: true),
    );
  });

  test('offers nothing on desktop, without asking the phone', () async {
    repository.supported = false;

    expect(
      (await GetAppLock(repository)()).dataOrNull,
      const AppLockStatus.off(),
    );
  });

  test('a cancelled prompt changes nothing', () async {
    repository.answer = false;
    const off = AppLockStatus(supported: true, available: true, enabled: false);

    final result = await SetAppLock(repository)(
      off,
      enabled: true,
      prompt: _prompt,
    );

    expect(result.dataOrNull, off);
    expect(repository.enabled, isFalse);
  });

  test('never turns on without a screen lock to check against', () async {
    const noScreenLock = AppLockStatus(
      supported: true,
      available: false,
      enabled: false,
    );

    final result = await SetAppLock(repository)(
      noScreenLock,
      enabled: true,
      prompt: _prompt,
    );

    expect(result.dataOrNull?.isOn, isFalse);
    expect(repository.prompts, isEmpty);
  });

  test('unlocking shows the phone\'s prompt with the given words', () async {
    final opened = await UnlockApp(repository)(_prompt);

    expect(opened.dataOrNull, isTrue);
    expect(repository.prompts, [_prompt]);
  });
}
