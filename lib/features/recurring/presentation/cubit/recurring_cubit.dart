import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/entities/recurring_payment.dart';
import '../../domain/usecases/delete_recurring_expense.dart';
import '../../domain/usecases/get_recurring_overview.dart';
import '../../domain/usecases/log_due_recurring.dart';
import '../../domain/usecases/mark_recurring_paid.dart';
import '../../domain/usecases/undo_recurring_payment.dart';
import 'recurring_state.dart';

/// Every recurring payment and where it stands today. Shared by the
/// recurring payments page and the home screen, which asks about reminders
/// that are due.
///
/// Every read first logs the automatic payments that have fallen due, so
/// opening the app, or coming back to it, is all it takes for them to land.
class RecurringCubit extends Cubit<RecurringState> {
  RecurringCubit({
    required GetRecurringOverview getOverview,
    required LogDueRecurring logDue,
    required MarkRecurringPaid markPaid,
    required UndoRecurringPayment undoPayment,
    required DeleteRecurringExpense deleteRecurring,
    DateTime Function()? clock,
  }) : _getOverview = getOverview,
       _logDue = logDue,
       _markPaid = markPaid,
       _undoPayment = undoPayment,
       _deleteRecurring = deleteRecurring,
       _clock = clock ?? DateTime.now,
       super(const RecurringLoading());

  final GetRecurringOverview _getOverview;
  final LogDueRecurring _logDue;
  final MarkRecurringPaid _markPaid;
  final UndoRecurringPayment _undoPayment;
  final DeleteRecurringExpense _deleteRecurring;
  final DateTime Function() _clock;

  int _ledgerVersion = 0;

  /// Counts reads, so that of two overlapping ones only the newer is shown.
  int _reads = 0;

  /// Payments being marked right now, so a double tap logs one.
  final Set<String> _paying = {};

  /// Kept only until the undo snackbar disappears.
  RecurringPayment? _lastPayment;

  /// First load: shows the spinner. Later calls should use [refresh].
  Future<void> load() async {
    emit(const RecurringLoading());
    await refresh();
  }

  /// Logs any automatic payment that has fallen due, then reads everything
  /// again. Also how a new day turns an upcoming payment overdue.
  Future<void> refresh() async {
    final logged = await _logDue(today: _clock());
    UiNotice? notice;
    switch (logged) {
      case Success(:final data) when data > 0:
        _ledgerVersion++;
        notice = UiNotice(NoticeCode.recurringAutoLogged, count: data);
      case Success():
        break;
      case ResultFailure(:final failure):
        // Some may have been logged before it failed.
        _ledgerVersion++;
        notice = UiNotice.from(failure);
    }
    await _fetch(notice: notice);
  }

  /// Logs the oldest unpaid payment of [recurring] as a transaction today.
  Future<void> markPaid(RecurringExpense recurring) async {
    if (!_paying.add(recurring.id)) return;
    final result = await _markPaid(recurring, now: _clock());
    _paying.remove(recurring.id);
    switch (result) {
      case Success(:final data):
        _lastPayment = data;
        _ledgerVersion++;
        await _fetch(
          notice: UiNotice(NoticeCode.recurringPaid, name: recurring.title),
        );
      case ResultFailure(:final failure):
        // Read again: an already-paid payment means the list was stale.
        await _fetch(notice: UiNotice.from(failure));
    }
  }

  Future<void> undoPayment() async {
    final payment = _lastPayment;
    if (payment == null) return;
    _lastPayment = null;

    final result = await _undoPayment(payment);
    switch (result) {
      case Success():
        _ledgerVersion++;
        await _fetch(notice: UiNotice(NoticeCode.recurringPaymentUndone));
      case ResultFailure(:final failure):
        await _fetch(notice: UiNotice.from(failure));
    }
  }

  Future<void> remove(RecurringExpense recurring) async {
    final result = await _deleteRecurring(recurring.id);
    if (_lastPayment?.recurringId == recurring.id) _lastPayment = null;
    await _fetch(
      notice: switch (result) {
        Success() => UiNotice(
          NoticeCode.recurringDeleted,
          name: recurring.title,
        ),
        ResultFailure(:final failure) => UiNotice.from(failure),
      },
    );
  }

  Future<void> _fetch({UiNotice? notice}) async {
    final read = ++_reads;
    final result = await _getOverview(today: _clock());
    if (isClosed || read != _reads) return;
    switch (result) {
      case Success(:final data):
        emit(
          RecurringReady(
            overview: data,
            ledgerVersion: _ledgerVersion,
            canUndoPayment: _lastPayment != null,
            notice: notice,
          ),
        );
      case ResultFailure(:final failure):
        emit(RecurringLoadFailure(failure.code));
    }
  }
}
