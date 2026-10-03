import 'package:equatable/equatable.dart';

import 'debt_balance.dart';
import 'person.dart';
import 'person_transaction.dart';
import 'settlement.dart';

/// A settlement and the transactions it cleared.
class SettledGroup extends Equatable {
  const SettledGroup({required this.settlement, required this.transactions});

  final Settlement settlement;

  /// Newest first.
  final List<PersonTransaction> transactions;

  @override
  List<Object?> get props => [settlement, transactions];
}

/// Everything recorded with one person: the open transactions that make up
/// the current balance, and the settled history.
class PersonLedger extends Equatable {
  const PersonLedger({
    required this.person,
    required this.open,
    required this.history,
  });

  final Person person;

  /// Newest first.
  final List<PersonTransaction> open;

  /// Newest settlement first.
  final List<SettledGroup> history;

  DebtBalance get balance => DebtBalance.of(open);

  /// Settling needs something to settle, even if it all cancels out.
  bool get canSettle => open.isNotEmpty;

  bool get isEmpty => open.isEmpty && history.isEmpty;

  @override
  List<Object?> get props => [person, open, history];
}
