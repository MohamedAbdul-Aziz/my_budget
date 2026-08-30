import 'package:equatable/equatable.dart';

/// The user tapped the home screen widget and wants to record an expense.
class QuickAddRequest extends Equatable {
  const QuickAddRequest({this.categoryId});

  /// Set when a category shortcut was tapped rather than the Add button, so
  /// the sheet opens with that category already chosen.
  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}
