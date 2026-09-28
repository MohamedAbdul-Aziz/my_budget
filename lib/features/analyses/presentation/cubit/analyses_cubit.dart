import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../domain/usecases/get_month_analysis.dart';
import 'analyses_state.dart';

/// The analyses of whichever month the home screen has selected.
class AnalysesCubit extends Cubit<AnalysesState> {
  AnalysesCubit({required GetMonthAnalysis getMonthAnalysis})
    : _getMonthAnalysis = getMonthAnalysis,
      super(const AnalysesLoading());

  final GetMonthAnalysis _getMonthAnalysis;

  /// Reloads without a spinner once something is showing, so switching
  /// months or adding an expense does not flash the page.
  Future<void> load(Month month) async {
    final result = await _getMonthAnalysis(month);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(AnalysesReady(data));
      case ResultFailure(:final failure):
        emit(AnalysesFailure(failure.code));
    }
  }
}
