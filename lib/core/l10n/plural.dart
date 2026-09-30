import 'package:intl/intl.dart';

/// Picks the form [count] takes in [locale] by the CLDR plural rules: Russian,
/// Polish and Ukrainian have `few` and `many` forms, French counts 0 as
/// `one`, and Chinese, Japanese and Korean only ever use [other].
String plural(
  int count, {
  required String locale,
  String? one,
  String? few,
  String? many,
  required String other,
}) => Intl.plural(
  count,
  locale: locale,
  one: one,
  few: few,
  many: many,
  other: other,
);
