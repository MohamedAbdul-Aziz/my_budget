import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/analyses/presentation/cubit/analyses_cubit.dart';
import 'package:my_budget/features/assistant/presentation/pages/assistant_page.dart';
import 'package:my_budget/features/auth/domain/entities/app_user.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

const _user = AppUser(id: 'user-1', email: 'me@example.com');

void main() {
  tearDown(() => sl.reset());

  /// Boots the app, signed in unless [signedIn] is false, and opens the
  /// assistant.
  Future<AppHarness> openAssistant(
    WidgetTester tester, {
    bool signedIn = true,
    bool consent = true,
  }) async {
    final harness = await bootApp(
      tester,
      before: (harness) {
        if (signedIn) harness.auth.currentUser = _user;
        harness.assistant.consent = consent;
      },
    );
    unawaited(
      Navigator.of(
        tester.element(find.byType(Scaffold).first),
      ).push(AssistantPage.route()),
    );
    await tester.pumpAndSettle();
    return harness;
  }

  Future<void> ask(WidgetTester tester, String question) async {
    await tester.enterText(find.byType(TextField), question);
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();
  }

  testWidgets('opens from the Ask card on the Analyses tab', (tester) async {
    await bootApp(tester, before: (h) => h.auth.currentUser = _user);
    await sl<AnalysesCubit>().load(Month.current());
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ask AI'));
    await tester.pumpAndSettle();

    expect(find.text('AI assistant'), findsOneWidget);
    expect(find.text('Before you ask'), findsOneWidget);
  });

  testWidgets('a guest is asked to sign in, and nothing is sent', (
    tester,
  ) async {
    final harness = await openAssistant(tester, signedIn: false);

    expect(
      find.text(
        'Sign in to use the AI assistant. Each account can ask 20 questions a day.',
      ),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNothing);
    expect(harness.assistant.asked, isEmpty);
  });

  testWidgets('asks for consent first, then lets the user ask', (tester) async {
    final harness = await openAssistant(tester, consent: false);

    expect(find.text('Before you ask'), findsOneWidget);
    expect(find.textContaining('Groq'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.text('I agree'));
    await tester.pumpAndSettle();

    expect(harness.assistant.consent, isTrue);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Where can I save?'), findsOneWidget);
  });

  testWidgets('a question gets its answer', (tester) async {
    final harness = await openAssistant(tester);
    harness.assistant.replies.add('Food is your biggest cost.');

    await ask(tester, 'What costs me most?');

    expect(find.text('What costs me most?'), findsOneWidget);
    expect(find.text('Food is your biggest cost.'), findsOneWidget);
    final sent = harness.assistant.asked.single;
    expect(sent.question, 'What costs me most?');
    expect(sent.languageCode, 'en');
    expect(sent.history, isEmpty);
    expect(sent.summary.months, hasLength(3));
  });

  testWidgets('a suggested question is sent as it is', (tester) async {
    final harness = await openAssistant(tester);

    await tester.tap(find.text('Where can I save?'));
    await tester.pumpAndSettle();

    expect(harness.assistant.asked.single.question, 'Where can I save?');
  });

  testWidgets('send is disabled while waiting for an answer', (tester) async {
    final harness = await openAssistant(tester);
    final gate = Completer<void>();
    harness.assistant.gate = gate;

    await tester.enterText(find.byType(TextField), 'How much this month?');
    await tester.tap(find.byTooltip('Send'));
    await tester.pump();

    final send = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.send),
        matching: find.byType(IconButton),
      ),
    );
    expect(send.onPressed, isNull);

    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('OK'), findsOneWidget);
  });

  testWidgets('earlier messages go along with the next question', (
    tester,
  ) async {
    final harness = await openAssistant(tester);
    harness.assistant.replies.addAll(['First answer', 'Second answer']);

    await ask(tester, 'First?');
    await ask(tester, 'Second?');

    expect(harness.assistant.asked[1].history.map((m) => m.text), [
      'First?',
      'First answer',
    ]);
  });

  for (final (code, message) in [
    (
      FailureCode.aiDailyLimit,
      "You've asked today's 20 questions. Try again tomorrow.",
    ),
    (FailureCode.aiBusy, 'The assistant is busy. Try again in a minute.'),
    (
      FailureCode.aiUnavailable,
      "The assistant isn't available right now. Try again later.",
    ),
  ]) {
    testWidgets('shows ${code.name} and can try again', (tester) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.addAll([
        AssistantFailure(code),
        'Answer after retry',
      ]);

      await ask(tester, 'How much?');
      expect(find.text(message), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsNothing);
      expect(find.text('Answer after retry'), findsOneWidget);
      // The question is shown once, not repeated by the retry.
      expect(find.text('How much?'), findsOneWidget);
      expect(harness.assistant.asked, hasLength(2));
    });
  }

  testWidgets('shows a network failure', (tester) async {
    final harness = await openAssistant(tester);
    harness.assistant.replies.add(const NetworkFailure());

    await ask(tester, 'How much?');

    expect(
      find.text("Couldn't connect. Check your internet and try again."),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('a session that ended on the server asks to sign in again', (
    tester,
  ) async {
    final harness = await openAssistant(tester);
    harness.assistant.replies.add(
      const AuthFailure(FailureCode.signInRequired),
    );

    await ask(tester, 'How much?');

    expect(find.byType(TextField), findsNothing);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('stop sharing withdraws consent', (tester) async {
    final harness = await openAssistant(tester);

    await tester.tap(find.byType(PopupMenuButton<void>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stop sharing'));
    await tester.pumpAndSettle();

    expect(harness.assistant.consent, isFalse);
    expect(find.text('Before you ask'), findsOneWidget);
  });

  testWidgets('in Arabic it lays out right to left and asks in Arabic', (
    tester,
  ) async {
    final harness = await openAssistant(tester);
    await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
    await tester.pumpAndSettle();

    expect(find.text('المساعد الذكي'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(TextField))),
      TextDirection.rtl,
    );

    await ask(tester, 'كم صرفت؟');

    expect(harness.assistant.asked.single.languageCode, 'ar');
    expect(tester.takeException(), isNull);
  });
}
