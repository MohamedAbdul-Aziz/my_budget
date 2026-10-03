import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../domain/entities/month_comparison.dart';

sealed class CompareMonthsState extends Equatable {
  const CompareMonthsState();

  @override
  List<Object?> get props => [];
}

final class CompareMonthsLoading extends CompareMonthsState {
  const CompareMonthsLoading();
}

final class CompareMonthsReady extends CompareMonthsState {
  const CompareMonthsReady({required this.comparison, required this.choices});

  final MonthComparison comparison;

  /// Months the user can compare with, newest first.
  final List<Month> choices;

  @override
  List<Object?> get props => [comparison, choices];
}

final class CompareMonthsFailure extends CompareMonthsState {
  const CompareMonthsFailure(this.error);

  final FailureCode error;

  @override
  List<Object?> get props => [error];
}
