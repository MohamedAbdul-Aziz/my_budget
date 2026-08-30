import 'package:equatable/equatable.dart';

/// Exactly what the home screen widget draws.
///
/// Everything is pre-rendered text: an Android widget cannot run the app's
/// formatters or localizations, so the app hands it finished strings in the
/// language and currency the user has chosen.
class QuickExpenseSnapshot extends Equatable {
  const QuickExpenseSnapshot({
    required this.title,
    required this.monthLabel,
    required this.total,
    required this.addLabel,
    required this.categories,
  });

  final String title;
  final String monthLabel;

  /// Already formatted, e.g. `$1,240`.
  final String total;
  final String addLabel;
  final List<QuickExpenseShortcut> categories;

  @override
  List<Object?> get props => [title, monthLabel, total, addLabel, categories];
}

/// One tappable category on the widget.
class QuickExpenseShortcut extends Equatable {
  const QuickExpenseShortcut({
    required this.categoryId,
    required this.name,
    required this.colorValue,
  });

  final String categoryId;

  /// Localized category name.
  final String name;

  /// ARGB, as stored on the category.
  final int colorValue;

  @override
  List<Object?> get props => [categoryId, name, colorValue];
}
