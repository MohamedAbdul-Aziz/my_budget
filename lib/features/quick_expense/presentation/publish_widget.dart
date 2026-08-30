import '../../../core/di/injection.dart';
import '../../../core/l10n/app_strings.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import 'quick_expense_widget_sync.dart';

/// Redraws the home screen widget from the current data.
///
/// Reads the language from settings rather than from the widget tree: callers
/// run while the tree is mid-rebuild, or — in the quick-add dialog — with no
/// home screen in the tree at all.
Future<void> publishQuickExpenseWidget() async {
  final settings = sl<SettingsCubit>().state;
  await sl<QuickExpenseWidgetSync>().refresh(
    strings: AppStrings.forLanguageCode(settings.languageCode),
    formats: settings.formats,
  );
}
