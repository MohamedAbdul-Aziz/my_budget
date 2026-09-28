import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/month_analysis.dart';

sealed class AnalysesState extends Equatable {
  const AnalysesState();

  @override
  List<Object?> get props => [];
}

final class AnalysesLoading extends AnalysesState {
  const AnalysesLoading();
}

final class AnalysesReady extends AnalysesState {
  const AnalysesReady(this.analysis);

  final MonthAnalysis analysis;

  @override
  List<Object?> get props => [analysis];
}

final class AnalysesFailure extends AnalysesState {
  const AnalysesFailure(this.error);

  final FailureCode error;

  @override
  List<Object?> get props => [error];
}
