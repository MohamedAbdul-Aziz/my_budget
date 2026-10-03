import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/data_management/domain/entities/export_format.dart';
import 'package:my_budget/features/data_management/domain/entities/import_mode.dart';

import 'app_harness.dart';

/// Settings → Data management, for guests (no account involved) unless a
/// test signs in.
void main() {
  tearDown(() => sl.reset());

  Future<void> openSettings(WidgetTester tester) async {
    // By icon, so the same step works whatever the app's language.
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final target = find.text(text);
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> closeSettings(WidgetTester tester) async {
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
  }

  testWidgets('guests can back up to a file and save it', (tester) async {
    final harness = await bootApp(tester);
    await openSettings(tester);

    expect(find.text('Data management'), findsOneWidget);
    await tapText(tester, 'Back up my data');

    expect(harness.files.exports, [ExportFormat.backup]);
    expect(harness.files.exportLocales.single.languageCode, 'en');
    expect(find.text('Your file is ready'), findsOneWidget);

    await tapText(tester, 'Save to this phone');

    expect(harness.files.saved, hasLength(1));
    expect(find.text('File saved'), findsOneWidget);
  });

  testWidgets('an export can go to the share sheet', (tester) async {
    final harness = await bootApp(tester);
    await openSettings(tester);

    await tapText(tester, 'Export as PDF');
    await tapText(tester, 'Share');

    expect(harness.files.exports, [ExportFormat.report]);
    expect(harness.files.shared, hasLength(1));
    expect(find.text('Your file is ready'), findsNothing);
  });

  testWidgets('cancelling the save dialog is not an error', (tester) async {
    final harness = await bootApp(tester);
    harness.files.saveConfirmed = false;
    await openSettings(tester);

    await tapText(tester, 'Export as CSV');
    await tapText(tester, 'Save to this phone');

    expect(harness.files.exports, [ExportFormat.spreadsheet]);
    expect(find.text('File saved'), findsNothing);
    expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
  });

  testWidgets('a failed export says why', (tester) async {
    final harness = await bootApp(tester);
    harness.files.exportFailure = const FileFailure(FailureCode.storageFull);
    await openSettings(tester);

    await tapText(tester, 'Back up my data');

    expect(
      find.text("There isn't enough free space on this phone."),
      findsOneWidget,
    );
    expect(find.text('Your file is ready'), findsNothing);
  });

  testWidgets('importing merges by default and refreshes the app', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    // The backup holds an expense this phone has never seen.
    harness.files.onImport = () async {
      await harness.expenses.addExpense(
        amount: 40,
        categoryId: 'cat_food',
        date: DateTime.now(),
      );
    };
    await openSettings(tester);

    await tapText(tester, 'Import data');

    expect(find.text('Import this backup?'), findsOneWidget);
    expect(
      find.text('Backup from Sep 1, 2026: 12 expenses and 9 categories.'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Merge'));
    await tester.pumpAndSettle();

    expect(harness.files.imports, [ImportMode.merge]);
    expect(find.text('Import complete'), findsOneWidget);

    await closeSettings(tester);
    expect(find.text('1 transaction'), findsOneWidget);
  });

  testWidgets('replacing needs a second, explicit confirmation', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    await openSettings(tester);

    await tapText(tester, 'Import data');
    await tester.tap(find.widgetWithText(TextButton, 'Replace everything'));
    await tester.pumpAndSettle();
    expect(find.text('Replace everything on this phone?'), findsOneWidget);

    // Backing out at the second step imports nothing.
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(harness.files.imports, isEmpty);

    await tapText(tester, 'Import data');
    await tester.tap(find.widgetWithText(TextButton, 'Replace everything'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Replace'));
    await tester.pumpAndSettle();

    expect(harness.files.imports, [ImportMode.replace]);
  });

  testWidgets('cancelling the import dialog imports nothing', (tester) async {
    final harness = await bootApp(tester);
    await openSettings(tester);

    await tapText(tester, 'Import data');
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(harness.files.imports, isEmpty);
    expect(find.text('Import this backup?'), findsNothing);
  });

  testWidgets('a file that is not a backup is refused before anything', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    harness.files.previewFailure = const FileFailure(
      FailureCode.backupNotRecognized,
    );
    await openSettings(tester);

    await tapText(tester, 'Import data');

    expect(find.text("This file isn't a My Budget backup."), findsOneWidget);
    expect(find.text('Import this backup?'), findsNothing);
    expect(harness.files.imports, isEmpty);
  });

  testWidgets('cancelling the file chooser does nothing', (tester) async {
    final harness = await bootApp(tester);
    harness.files.pickedPath = null;
    await openSettings(tester);

    await tapText(tester, 'Import data');

    expect(find.text('Import this backup?'), findsNothing);
    expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
  });

  testWidgets('exports follow the app language', (tester) async {
    final harness = await bootApp(tester, localeName: 'ar_EG');
    await openSettings(tester);

    expect(find.text('إدارة البيانات'), findsOneWidget);
    await tapText(tester, 'تصدير بصيغة PDF');

    final locale = harness.files.exportLocales.single;
    expect(locale.languageCode, 'ar');
    expect(locale.isRightToLeft, isTrue);
  });

  testWidgets('signed-in users have both cloud and local backup', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    harness.auth.openConfirmationLink('mohamed@example.com');
    await tester.pumpAndSettle();
    await openSettings(tester);

    expect(find.text('Back up now'), findsOneWidget);
    await tester.ensureVisible(find.text('Back up my data'));
    expect(find.text('Back up my data'), findsOneWidget);
  });
}
