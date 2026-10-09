import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/usecases/get_monthly_summaries.dart';
import '../../domain/usecases/compare_months.dart';
import 'compare_months_state.dart';

/// Any two months the user picks, set against each other. Lives only while the
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

  /// The month the page shows; the comparison starts from it.
  Month? _pageMonth;

  /// Compares [pageMonth] with the month before it. Called again with the
  /// same month (a logged expense, say), it keeps the two months the user
  /// picked and only refreshes the figures.
  Future<void> load(Month pageMonth) async {
    final current = state;
    final samePage = _pageMonth == pageMonth;
    _pageMonth = pageMonth;
    if (samePage && current is CompareMonthsReady) {
      await _compare(current.comparison.first, current.comparison.second);
    } else {
      await _compare(pageMonth, pageMonth.previous);
    }
  }

  /// Changes either side of the comparison. Picking the month already on
  /// the other side swaps the two, so they can never be the same.
  Future<void> pick({Month? first, Month? second}) async {
    final current = state;
    if (current is! CompareMonthsReady) return;
    final was = current.comparison;
    var newFirst = first ?? was.first;
    var newSecond = second ?? was.second;
    if (newFirst == newSecond) {
      if (first != null) {
        newSecond = was.first;
      } else {
        newFirst = was.second;
      }
    }
    await _compare(newFirst, newSecond);
  }

  Future<void> _compare(Month first, Month second) async {
    final summaries = await _getMonthlySummaries();
    if (isClosed) return;
    if (summaries case ResultFailure(:final failure)) {
      emit(CompareMonthsFailure(failure.code));
      return;
    }

    // Months with spending, plus the page's month and the one before it so
    // there is always something to pick, even in a first month.
    final pageMonth = _pageMonth ?? first;
    final choices = {
      pageMonth,
      pageMonth.previous,
      first,
      second,
      for (final summary in summaries.dataOrNull!) summary.month,
    }.toList()..sort((a, b) => b.compareTo(a));

    final result = await _compareMonths(first, second);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(CompareMonthsReady(comparison: data, choices: choices));
      case ResultFailure(:final failure):
        emit(CompareMonthsFailure(failure.code));
    }
  }
}
