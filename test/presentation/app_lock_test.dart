import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/l10n/app_strings.dart';
import 'package:my_budget/features/app_lock/domain/entities/app_lock_prompt.dart';
import 'package:my_budget/features/app_lock/domain/usecases/get_app_lock.dart';
import 'package:my_budget/features/app_lock/domain/usecases/set_app_lock.dart';
import 'package:my_budget/features/app_lock/domain/usecases/unlock_app.dart';
import 'package:my_budget/features/app_lock/presentation/cubit/app_lock_cubit.dart';
import 'package:my_budget/features/app_lock/presentation/cubit/app_lock_state.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';

import 'app_harness.dart';
import 'fakes.dart';

void main() {
  tearDown(() => sl.reset());

  final unlockButton = find.text('Unlock');
  final lockSwitch = find.widgetWithText(SwitchListTile, 'App lock');

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Security'));
    await tester.pumpAndSettle();
  }

  testWidgets('a locked app opens behind the lock screen', (tester) async {
    final harness = await bootApp(
      tester,
      before: (harness) => harness.appLock
        ..enabled = true
        // The owner cancels the prompt that shows at launch.
        ..answer = false,
    );

    expect(harness.appLock.prompts.single.reason, 'Unlock to see your budget');
    expect(unlockButton, findsOneWidget);
    // The app is there, but nothing in it can be reached.
    await tester.tap(find.byTooltip('Settings'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Security'), findsNothing);

    harness.appLock.answer = true;
    await tester.tap(unlockButton);
    await tester.pumpAndSettle();

    expect(unlockButton, findsNothing);
    expect(harness.appLock.prompts, hasLength(2));
    await openSettings(tester);
    expect(find.text('Security'), findsOneWidget);
  });

  testWidgets('opens straight away once the phone confirms the owner', (
    tester,
  ) async {
    final harness = await bootApp(
      tester,
      before: (harness) => harness.appLock.enabled = true,
    );

    expect(harness.appLock.prompts, hasLength(1));
    expect(unlockButton, findsNothing);
  });

  testWidgets('never asks while the lock is off', (tester) async {
    final harness = await bootApp(tester);

    expect(harness.appLock.prompts, isEmpty);
    expect(unlockButton, findsNothing);
  });

  testWidgets('turning the lock on or off needs the owner', (tester) async {
    final harness = await bootApp(tester);
    await openSettings(tester);
    expect(tester.widget<SwitchListTile>(lockSwitch).value, isFalse);

    // Someone else holding the phone cancels the prompt: nothing changes.
    harness.appLock.answer = false;
    await tester.tap(lockSwitch);
    await tester.pumpAndSettle();
    expect(harness.appLock.enabled, isFalse);
    expect(
      harness.appLock.prompts.single.reason,
      "Confirm it's you to change the app lock",
    );

    harness.appLock.answer = true;
    await tester.tap(lockSwitch);
    await tester.pumpAndSettle();
    expect(harness.appLock.enabled, isTrue);
    expect(tester.widget<SwitchListTile>(lockSwitch).value, isTrue);

    await tester.tap(lockSwitch);
    await tester.pumpAndSettle();
    expect(harness.appLock.enabled, isFalse);
    expect(harness.appLock.prompts, hasLength(3));
  });

  testWidgets('a phone with no screen lock cannot turn it on', (tester) async {
    await bootApp(
      tester,
      before: (harness) => harness.appLock.available = false,
    );
    await openSettings(tester);

    expect(tester.widget<SwitchListTile>(lockSwitch).onChanged, isNull);
    expect(
      find.text('Set up a screen lock on this phone to use this'),
      findsOneWidget,
    );
  });

  testWidgets('is left out where no lock is offered', (tester) async {
    await bootApp(
      tester,
      before: (harness) => harness.appLock.supported = false,
    );
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Security'), findsNothing);
  });

  for (final language in AppLanguage.translated) {
    testWidgets('the lock screen fits a small phone in ${language.name}', (
      tester,
    ) async {
      // 360 × 740 logical pixels. An overflow anywhere fails the test.
      tester.view.physicalSize = const Size(1080, 2220);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final harness = await bootApp(
        tester,
        localeName: language.languageCode!,
        before: (harness) => harness.appLock
          ..enabled = true
          ..answer = false,
      );

      final strings = AppStrings.forLanguageCode(language.languageCode);
      expect(find.text(strings.unlock), findsOneWidget);
      expect(find.text(strings.unlockToContinue), findsOneWidget);
      // The phone's own prompt is worded in the app's language too.
      expect(harness.appLock.prompts.single.reason, strings.unlockToContinue);
      expect(harness.appLock.prompts.single.cancel, strings.cancel);
    });
  }

  group('coming back to the app', () {
    late FakeAppLockRepository repository;
    late DateTime now;
    late AppLockCubit cubit;

    setUp(() async {
      repository = FakeAppLockRepository()..enabled = true;
      now = DateTime(2026, 10, 1, 9);
      cubit = AppLockCubit(
        getAppLock: GetAppLock(repository),
        setAppLock: SetAppLock(repository),
        unlockApp: UnlockApp(repository),
        clock: () => now,
      );
      await cubit.load();
      expect(cubit.state, isA<AppLockLocked>());
      await cubit.unlock(
        const AppLockPrompt(reason: 'r', title: 't', cancel: 'c'),
      );
      expect(cubit.state, isA<AppLockOpen>());
    });

    tearDown(() => cubit.close());

    test('within a minute stays open', () {
      cubit.noteHidden();
      now = now.add(const Duration(seconds: 59));
      cubit.noteShown();

      expect(cubit.state, isA<AppLockOpen>());
    });

    test('after a minute or more locks again', () {
      cubit.noteHidden();
      now = now.add(AppLockCubit.gracePeriod);
      cubit.noteShown();

      expect(cubit.state, isA<AppLockLocked>());
    });

    test(
      'a phone whose screen lock was removed opens without asking',
      () async {
        cubit.noteHidden();
        now = now.add(const Duration(minutes: 5));
        cubit.noteShown();
        repository
          ..available = false
          ..answer = false;

        await cubit.unlock(
          const AppLockPrompt(reason: 'r', title: 't', cancel: 'c'),
        );

        expect(cubit.state, isA<AppLockOpen>());
        expect(repository.prompts, hasLength(1));
      },
    );
  });
}
