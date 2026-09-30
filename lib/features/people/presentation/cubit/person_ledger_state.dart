import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/person_ledger.dart';

sealed class PersonLedgerState extends Equatable {
  const PersonLedgerState();

  @override
  List<Object?> get props => [];
}

final class PersonLedgerLoading extends PersonLedgerState {
  const PersonLedgerLoading();
}

final class PersonLedgerLoadFailure extends PersonLedgerState {
  const PersonLedgerLoadFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class PersonLedgerReady extends PersonLedgerState {
  const PersonLedgerReady({required this.ledger, this.notice});

  final PersonLedger ledger;

  /// Set for one emission after a change or an error.
  final UiNotice? notice;

  @override
  List<Object?> get props => [ledger, notice];
}
