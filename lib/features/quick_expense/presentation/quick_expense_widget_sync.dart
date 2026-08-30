import '../../../core/error/api_result.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/utils/app_formats.dart';
import '../../categories/presentation/category_label.dart';
import '../domain/entities/quick_expense_snapshot.dart';
import '../domain/usecases/get_quick_expense_data.dart';
import '../domain/usecases/publish_quick_expense_widget.dart';

/// Renders the home screen widget's contents in the language and currency the
/// user has chosen, then hands the finished strings to Android.
///
/// Lives in the presentation layer because that is where wording and
/// formatting belong — the widget itself cannot do either.
class QuickExpenseWidgetSync {
  const QuickExpenseWidgetSync({
    required GetQuickExpenseData getData,
    required PublishQuickExpenseWidget publish,
  }) : _getData = getData,
       _publish = publish;

  final GetQuickExpenseData _getData;
  final PublishQuickExpenseWidget _publish;

  /// Best effort: a widget that fails to refresh must never disturb the app,
  /// so failures are swallowed and the widget simply keeps its last contents.
  Future<void> refresh({
    required AppStrings strings,
    required AppFormats formats,
  }) async {
    final result = await _getData();
    if (result case Success(:final data)) {
      await _publish(
        QuickExpenseSnapshot(
          title: strings.quickExpense,
          monthLabel: formats.monthLabel(data.month),
          total: formats.moneyTight(data.monthTotal),
          addLabel: strings.addExpense,
          categories: [
            for (final category in data.categories)
              QuickExpenseShortcut(
                categoryId: category.id,
                name: categoryLabel(strings, category),
                colorValue: category.colorValue,
              ),
          ],
        ),
      );
    }
  }
}
