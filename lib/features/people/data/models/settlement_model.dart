import '../../domain/entities/debt_balance.dart';
import '../../domain/entities/settlement.dart';

/// Maps a `settlements` row to the domain entity.
abstract final class SettlementModel {
  static Settlement fromMap(Map<String, Object?> map) => Settlement(
    id: map['id']! as String,
    personId: map['person_id']! as String,
    balance: DebtBalance.fromAmount((map['net_amount']! as num).toDouble()),
    settledAt: DateTime.fromMillisecondsSinceEpoch(
      (map['settled_at']! as num).toInt(),
    ),
    expenseId: map['expense_id'] as String?,
  );
}
