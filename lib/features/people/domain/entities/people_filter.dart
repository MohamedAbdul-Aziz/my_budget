import 'debt_balance.dart';
import 'person_summary.dart';

/// The choices above the people list.
enum PeopleFilter {
  all,
  owedToMe,
  iOwe,
  settled;

  bool matches(PersonSummary summary) => switch (this) {
    all => true,
    owedToMe => summary.balance.direction == DebtDirection.owedToMe,
    iOwe => summary.balance.direction == DebtDirection.iOwe,
    settled => summary.balance.direction == DebtDirection.settled,
  };
}
