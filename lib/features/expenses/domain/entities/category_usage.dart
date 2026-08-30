import 'package:equatable/equatable.dart';

/// How often a category has been used. Drives the quick-entry shortcuts on the
/// home screen widget.
class CategoryUsage extends Equatable {
  const CategoryUsage({required this.categoryId, required this.count});

  final String categoryId;
  final int count;

  @override
  List<Object?> get props => [categoryId, count];
}
