import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/transaction_type.dart';
import 'debt_balance.dart';

/// One settle-up with a person: every transaction that was open at that
/// moment, cleared together.
class Settlement extends Equatable {
  const Settlement({
    required this.id,
    required this.personId,
    required this.balance,
    required this.settledAt,
    this.expenseId,
  });

  final String id;
  final String personId;

  /// The balance it cleared: positive when the person paid the user back,
  /// negative when the user paid the person, zero when the transactions
  /// cancelled each other out.
  final DebtBalance balance;
  final DateTime settledAt;

  /// The budget transaction the user logged for this settlement, if any.
  final String? expenseId;

  bool get isLoggedToBudget => expenseId != null;

  /// How the settlement enters the monthly budget if the user logs it:
  /// money received is income, money paid out is an expense. Null when no
  /// money changed hands.
  TransactionType? get budgetType => switch (balance.direction) {
    DebtDirection.owedToMe => TransactionType.income,
    DebtDirection.iOwe => TransactionType.expense,
    DebtDirection.settled => null,
  };

  @override
  List<Object?> get props => [id, personId, balance, settledAt, expenseId];
}
