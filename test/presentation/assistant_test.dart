import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/analyses/presentation/cubit/analyses_cubit.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_reply.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_sharing.dart';
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

  testWidgets('a guest can ask without an account', (tester) async {
    final harness = await openAssistant(tester, signedIn: false);
    harness.assistant.replies.add('Food costs most.');

    await ask(tester, 'What costs me most?');

    expect(find.text('Food costs most.'), findsOneWidget);
    expect(harness.assistant.asked, hasLength(1));
    expect(find.text('Sign in'), findsNothing);
  });

  testWidgets('the Ask AI button works for a guest too', (tester) async {
    await bootApp(tester, before: (h) => h.assistant.consent = true);
    await sl<AnalysesCubit>().load(Month.current());
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ask AI'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
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
      "You've reached today's limit for the assistant. Try again tomorrow.",
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

  group('saved chats', () {
    Future<void> openHistory(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Chat history'));
      await tester.pumpAndSettle();
    }

    /// Leaves the assistant and comes back, the way a user would later on.
    Future<void> reopen(WidgetTester tester) async {
      Navigator.of(tester.element(find.byType(TextField))).pop();
      await tester.pumpAndSettle();
      unawaited(
        Navigator.of(
          tester.element(find.byType(Scaffold).first),
        ).push(AssistantPage.route()),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('an answered chat is kept and opens again from history', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.addAll(['Food costs most.', 'About 20%.']);
      await ask(tester, 'What costs me most?');
      await ask(tester, 'How much of it?');

      await reopen(tester);
      // A fresh page starts a new chat.
      expect(find.text('Food costs most.'), findsNothing);
      expect(find.text('Where can I save?'), findsOneWidget);

      await openHistory(tester);
      expect(find.text('What costs me most?'), findsOneWidget);
      await tester.tap(find.text('What costs me most?'));
      await tester.pumpAndSettle();

      expect(find.text('Food costs most.'), findsOneWidget);
      expect(find.text('About 20%.'), findsOneWidget);

      // Carrying on sends the reopened conversation along and adds to the
      // same chat.
      await ask(tester, 'And last month?');
      expect(harness.assistant.asked.last.history.map((m) => m.text), [
        'What costs me most?',
        'Food costs most.',
        'How much of it?',
        'About 20%.',
      ]);
      expect(harness.assistant.chats, hasLength(1));
      expect(harness.assistant.chats.values.single.messages, hasLength(6));
    });

    testWidgets('new chat clears the screen and starts another chat', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.addAll(['First answer', 'Second answer']);
      await ask(tester, 'First?');

      await tester.tap(find.byTooltip('New chat'));
      await tester.pumpAndSettle();
      expect(find.text('First answer'), findsNothing);
      expect(find.text('Where can I save?'), findsOneWidget);

      await ask(tester, 'Second?');
      expect(harness.assistant.asked.last.history, isEmpty);
      expect(harness.assistant.chats, hasLength(2));
    });

    testWidgets('a question that got no answer is not saved', (tester) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.add(const AssistantFailure(FailureCode.aiBusy));

      await ask(tester, 'How much?');

      expect(harness.assistant.chats, isEmpty);
      await openHistory(tester);
      expect(
        find.text(
          'No saved chats yet. Your chats with the assistant are kept on this phone only.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a chat that could not be saved still shows its answer', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      harness.assistant
        ..saveFailure = const DatabaseFailure()
        ..replies.add('Still here.');

      await ask(tester, 'How much?');

      expect(find.text('Still here.'), findsOneWidget);
      expect(harness.assistant.chats, isEmpty);
    });

    testWidgets('new chat and history wait while a question is on its way', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      final gate = Completer<void>();
      harness.assistant.gate = gate;

      await tester.enterText(find.byType(TextField), 'How much?');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      for (final tooltip in ['New chat', 'Chat history']) {
        final button = tester.widget<IconButton>(
          find.ancestor(
            of: find.byTooltip(tooltip),
            matching: find.byType(IconButton),
          ),
        );
        expect(button.onPressed, isNull, reason: tooltip);
      }

      gate.complete();
      await tester.pumpAndSettle();
      expect(harness.assistant.chats, hasLength(1));
    });

    testWidgets('deletes one chat, then all of them, after asking', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.addAll(['A', 'B', 'C']);
      for (final question in ['One?', 'Two?', 'Three?']) {
        await ask(tester, question);
        await tester.tap(find.byTooltip('New chat'));
        await tester.pumpAndSettle();
      }
      await openHistory(tester);
      expect(find.byIcon(Icons.chat_bubble_outline), findsNWidgets(3));

      // Deleting one asks first; cancelling keeps it.
      final two = find.ancestor(
        of: find.text('Two?'),
        matching: find.byType(ListTile),
      );
      await tester.tap(
        find.descendant(of: two, matching: find.byIcon(Icons.delete_outline)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Delete this chat?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(harness.assistant.chats, hasLength(3));

      await tester.tap(
        find.descendant(of: two, matching: find.byIcon(Icons.delete_outline)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Two?'), findsNothing);
      expect(harness.assistant.chats, hasLength(2));

      await tester.tap(find.byTooltip('Delete all chats'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Every saved chat with the assistant will be deleted from this phone.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(harness.assistant.chats, isEmpty);
      expect(find.byIcon(Icons.chat_bubble_outline), findsNothing);
    });

    testWidgets('stopping sharing keeps the saved chats', (tester) async {
      final harness = await openAssistant(tester);
      await ask(tester, 'How much?');

      await tester.tap(find.byType(PopupMenuButton<void>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Stop sharing'));
      await tester.pumpAndSettle();

      expect(harness.assistant.consent, isFalse);
      expect(harness.assistant.chats, hasLength(1));
      expect(find.byTooltip('Chat history'), findsNothing);
    });

    testWidgets('history reads right to left in Arabic', (tester) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.add('جواب');
      await ask(tester, 'كم صرفت؟');
      await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.text('سجل المحادثات'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('كم صرفت؟'))),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('what to share', () {
    Future<void> openSharing(WidgetTester tester) async {
      await tester.tap(find.byTooltip('What to share'));
      await tester.pumpAndSettle();
    }

    SwitchListTile switchTile(WidgetTester tester, String title) => tester
        .widget<SwitchListTile>(find.widgetWithText(SwitchListTile, title));

    testWidgets('by default only the summary goes, and no notice shows', (
      tester,
    ) async {
      final harness = await openAssistant(tester);

      await ask(tester, 'How much?');

      expect(harness.assistant.asked.single.summary.transactions, isNull);
      expect(harness.assistant.asked.single.summary.months, hasLength(3));
      expect(find.text("You're sharing more than the summary."), findsNothing);
    });

    testWidgets('the choices are saved and sent with the next question', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      await harness.expenses.addExpense(
        amount: 42,
        categoryId: 'cat_food',
        date: DateTime.now(),
        description: 'Groceries at the market',
      );

      await openSharing(tester);
      // Notes wait for transactions.
      expect(switchTile(tester, 'Notes').onChanged, isNull);
      await tester.tap(find.text('6 months'));
      await tester.tap(find.text('Transactions'));
      await tester.pumpAndSettle();
      expect(switchTile(tester, 'Notes').onChanged, isNotNull);
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();

      expect(harness.assistant.sharing.range, AssistantRange.last6Months);
      expect(harness.assistant.sharing.sendsDescriptions, isTrue);

      Navigator.of(tester.element(find.text('What to share').last)).pop();
      await tester.pumpAndSettle();
      expect(
        find.text("You're sharing more than the summary."),
        findsOneWidget,
      );

      await ask(tester, 'Where did it go?');
      final summary = harness.assistant.asked.single.summary;
      expect(summary.months, hasLength(6));
      expect(summary.transactions!.single.note, 'Groceries at the market');
    });

    testWidgets('choices made earlier come back with the page', (tester) async {
      final harness = await bootApp(
        tester,
        before: (h) {
          h.auth.currentUser = _user;
          h.assistant
            ..consent = true
            ..sharing = const AssistantSharing(people: true);
        },
      );
      unawaited(
        Navigator.of(
          tester.element(find.byType(Scaffold).first),
        ).push(AssistantPage.route()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text("You're sharing more than the summary."),
        findsOneWidget,
      );
      await ask(tester, 'Who owes me?');
      expect(harness.assistant.asked.single.summary.people, isNotNull);
    });

    testWidgets('summary only puts everything back to the default', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      await openSharing(tester);
      await tester.tap(find.text('Recurring payments'));
      await tester.pumpAndSettle();
      expect(harness.assistant.sharing.recurring, isTrue);

      await tester.ensureVisible(find.text('Summary only'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Summary only'));
      await tester.pumpAndSettle();

      expect(harness.assistant.sharing, AssistantSharing.defaults);
      expect(switchTile(tester, 'Recurring payments').value, isFalse);
    });

    testWidgets('the sheet reads right to left in Arabic', (tester) async {
      await openAssistant(tester);
      await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      expect(find.text('ماذا تشارك'), findsWidgets);
      expect(
        Directionality.of(tester.element(find.text('العمليات'))),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('answers', () {
    testWidgets('never show a count of questions, only that the day is over', (
      tester,
    ) async {
      final harness = await openAssistant(tester, signedIn: false);
      harness.assistant.replies.add(
        const AssistantFailure(FailureCode.aiDailyLimit),
      );

      await ask(tester, 'How much?');

      expect(
        find.text(
          "You've reached today's limit for the assistant. Try again tomorrow.",
        ),
        findsOneWidget,
      );
      expect(find.textContaining('20'), findsNothing);
    });

    testWidgets('suggested follow-ups show after the answer and can be asked', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.addAll([
        const AssistantReply(
          answer: 'Food costs most.',
          followUps: ['And last month?', 'Where can I cut back?'],
        ),
        'Less than now.',
      ]);

      await ask(tester, 'What costs me most?');
      expect(find.text('And last month?'), findsOneWidget);
      expect(find.text('Where can I cut back?'), findsOneWidget);

      await tester.tap(find.text('And last month?'));
      await tester.pumpAndSettle();

      expect(harness.assistant.asked.last.question, 'And last month?');
      expect(find.text('Less than now.'), findsOneWidget);
      // The new answer brought none, so the old ones are gone.
      expect(find.text('Where can I cut back?'), findsNothing);
    });

    testWidgets('follow-ups are not saved with the chat', (tester) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.add(
        const AssistantReply(answer: 'Food.', followUps: ['Why?']),
      );
      await ask(tester, 'What costs most?');

      expect(
        harness.assistant.chats.values.single.messages.map((m) => m.text),
        ['What costs most?', 'Food.'],
      );
    });

    testWidgets('Markdown is drawn, not shown as symbols', (tester) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.add(
        '### Summary\n**Food** is your *biggest* cost.\n\n- Rent: 3000\n1. Cook more',
      );

      await ask(tester, 'Explain');

      expect(find.textContaining('**'), findsNothing);
      expect(find.textContaining('###'), findsNothing);
      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Food is your biggest cost.'), findsOneWidget);
      expect(find.text('Rent: 3000'), findsOneWidget);
      expect(find.text('•'), findsOneWidget);
      expect(find.text('1.'), findsOneWidget);
    });

    testWidgets('copy puts the answer, without marks, on the clipboard', (
      tester,
    ) async {
      String? clipboard;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboard = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final harness = await openAssistant(tester);
      harness.assistant.replies.add('**Food** costs most.\n- Rent');
      await ask(tester, 'Explain');

      await tester.tap(find.byTooltip('Copy'));
      await tester.pumpAndSettle();

      expect(clipboard, 'Food costs most.\n• Rent');
      expect(find.text('Answer copied'), findsOneWidget);
    });

    testWidgets('a long press offers copy and share; share sends plain text', (
      tester,
    ) async {
      final harness = await openAssistant(tester);
      harness.assistant.replies.add('**Food** costs most.');
      await ask(tester, 'Explain');

      await tester.longPress(find.text('Food costs most.'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ListTile, 'Copy'), findsOneWidget);
      await tester.tap(find.widgetWithText(ListTile, 'Share'));
      await tester.pumpAndSettle();

      expect(harness.assistant.shared, ['Food costs most.']);
    });

    testWidgets('a share sheet that will not open says so', (tester) async {
      final harness = await openAssistant(tester);
      harness.assistant
        ..replies.add('Food.')
        ..shareFailure = const FileFailure(FailureCode.shareUnavailable);
      await ask(tester, 'Explain');

      await tester.tap(find.byTooltip('Share'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(harness.assistant.shared, isEmpty);
    });
  });
}
