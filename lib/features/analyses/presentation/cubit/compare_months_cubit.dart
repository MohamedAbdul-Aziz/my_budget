import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/usecases/get_monthly_summaries.dart';
import '../../domain/usecases/compare_months.dart';
import 'compare_months_state.dart';

/// One month set against another the user picks. Lives only while the
/// "compare months" answer is open.
class CompareMonthsCubit extends Cubit<CompareMonthsState> {
  CompareMonthsCubit({
    required CompareMonths compareMonths,
    required GetMonthlySummaries getMonthlySummaries,
  }) : _compareMonths = compareMonths,
       _getMonthlySummaries = getMonthlySummaries,
       super(const CompareMonthsLoading());

  final CompareMonths _compareMonths;
  final GetMonthlySummaries _getMonthlySummaries;

  /// Compares [month] with [other], or with the month before it the first
  /// time. Reloading keeps whichever month the user already picked.
  Future<void> load(Month month, {Month? other}) async {
    final current = state;
    final summaries = await _getMonthlySummaries();
    if (isClosed) return;
    if (summaries case ResultFailure(:final failure)) {
      emit(CompareMonthsFailure(failure.code));
      return;
    }

    // Months with spending, plus the one before [month] so there is always
    // something to pick even in a first month.
    final choices = {
      month.previous,
      for (final summary in summaries.dataOrNull!) summary.month,
    }.where((m) => m != month).toList()..sort((a, b) => b.compareTo(a));

    final picked =
        other ??
        (current is CompareMonthsReady &&
                current.comparison.second != month &&
                choices.contains(current.comparison.second)
            ? current.comparison.second
            : month.previous);

    final result = await _compareMonths(month, picked);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(CompareMonthsReady(comparison: data, choices: choices));
      case ResultFailure(:final failure):
        emit(CompareMonthsFailure(failure.code));
    }
  }
}
