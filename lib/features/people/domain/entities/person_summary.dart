import 'package:equatable/equatable.dart';

import 'debt_balance.dart';
import 'person.dart';

/// A person as the people list shows them: who, and where the user stands.
class PersonSummary extends Equatable {
  const PersonSummary({
    required this.person,
    required this.balance,
    required this.openCount,
    this.lastActivity,
  });

  final Person person;

  /// Over the open transactions only.
  final DebtBalance balance;
  final int openCount;

  /// The date of the newest transaction, open or settled; null before the
  /// first one.
  final DateTime? lastActivity;

  @override
  List<Object?> get props => [person, balance, openCount, lastActivity];
}
