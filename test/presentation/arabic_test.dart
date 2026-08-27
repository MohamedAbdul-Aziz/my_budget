import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

/// Switches the app to Arabic the way the settings sheet does.
Future<void> _switchToArabic(WidgetTester tester) async {
  await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() => sl.reset());

  testWidgets('switching to Arabic translates the home screen', (
    tester,
  ) async {
    await bootApp(tester);
    expect(find.text('Nothing recorded yet'), findsOneWidget);

    await _switchToArabic(tester);

    expect(find.text('لا توجد مصروفات بعد'), findsOneWidget);
    expect(find.text('إضافة'), findsOneWidget);
    expect(find.text('Nothing recorded yet'), findsNothing);
  });

  testWidgets('Arabic lays the app out right to left', (tester) async {
    await bootApp(tester);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.ltr,
    );

    await _switchToArabic(tester);

    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.rtl,
    );
  });

  testWidgets('built-in category names are translated', (tester) async {
    await bootApp(tester);
    await _switchToArabic(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'إضافة'));
    await tester.pumpAndSettle();

    expect(find.text('مصروف جديد'), findsOneWidget);
    expect(find.text('طعام'), findsWidgets);
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('إضافة مصروف'), findsOneWidget);
  });

  testWidgets('an Arabic device starts in Arabic', (tester) async {
    await bootApp(tester, localeName: 'ar_EG');

    expect(find.text('لا توجد مصروفات بعد'), findsOneWidget);
  });

  testWidgets('validation errors are shown in Arabic', (tester) async {
    await bootApp(tester);
    await _switchToArabic(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'إضافة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة مصروف'));
    await tester.pumpAndSettle();

    expect(find.text('أدخل مبلغًا صحيحًا.'), findsOneWidget);
  });
}
