import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/recurring_overview.dart';

sealed class RecurringState extends Equatable {
  const RecurringState();

  @override
  List<Object?> get props => [];
}

final class RecurringLoading extends RecurringState {
  const RecurringLoading();
}

final class RecurringLoadFailure extends RecurringState {
  const RecurringLoadFailure(this.error);

  final FailureCode error;

  @override
  List<Object?> get props => [error];
}

final class RecurringReady extends RecurringState {
  const RecurringReady({
    required this.overview,
    required this.ledgerVersion,
    this.canUndoPayment = false,
    this.notice,
  });

  final RecurringOverview overview;

  /// Goes up every time this cubit adds or removes a transaction, so the
  /// screens showing transactions know to read them again.
  final int ledgerVersion;

  /// True while the last payment marked can still be taken back.
  final bool canUndoPayment;

  /// Set for one emission after a payment, a delete or an error.
  final UiNotice? notice;

  @override
  List<Object?> get props => [overview, ledgerVersion, canUndoPayment, notice];
}
