import 'expense_category.dart';
import 'transaction_type.dart';

/// When two category names count as the same name.
///
/// People type the same word in slightly different ways: "Food", " food",
/// "FOOD"; in Arabic "أكل" and "اكل", "هدية" and "هديه", with or without
/// diacritics or a stretched letter. All of those are one category, so a
/// second one is refused and an imported one is merged into the first.
abstract final class CategoryName {
  static final RegExp _spaces = RegExp(r'\s+');

  /// Arabic diacritics (harakat, shadda, sukun, dagger alef) and the
  /// tatweel used to stretch a word.
  static final RegExp _marks = RegExp('[ً-ْٰـ]');

  /// The form two names are compared in.
  static String key(String name) => name
      .trim()
      .replaceAll(_spaces, ' ')
      .toLowerCase()
      .replaceAll(_marks, '')
      .replaceAll(RegExp('[أإآٱ]'), 'ا') // أ إ آ ٱ → ا
      .replaceAll('ى', 'ي') // ى → ي
      .replaceAll('ی', 'ي') // Persian ی → ي
      .replaceAll('ک', 'ك') // Persian ک → ك
      .replaceAll('ة', 'ه'); // ة → ه

  /// Whether [name] is already used by another category of [type] among
  /// [categories]. [exceptId] is the category being renamed, which may keep
  /// its own name. The same name for spending and for income is allowed: a
  /// gift bought and a gift received are different things.
  static bool isTaken(
    String name,
    TransactionType type,
    Iterable<ExpenseCategory> categories, {
    String? exceptId,
  }) {
    final wanted = key(name);
    return categories.any(
      (category) =>
          category.id != exceptId &&
          category.type == type &&
          key(category.name) == wanted,
    );
  }
}
