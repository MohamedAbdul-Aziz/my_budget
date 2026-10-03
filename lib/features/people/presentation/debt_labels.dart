import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/status_colors.dart';
import '../domain/entities/debt_balance.dart';
import '../domain/entities/people_filter.dart';
import '../domain/entities/person_transaction_type.dart';

/// Green when the person owes the user, red when the user owes them, grey
/// when nothing is owed. Readable as text on the app's surfaces.
Color debtColor(BuildContext context, DebtDirection direction) =>
    switch (direction) {
      DebtDirection.owedToMe => StatusColors.of(context).good,
      DebtDirection.iOwe => StatusColors.of(context).danger,
      DebtDirection.settled => Theme.of(context).colorScheme.onSurfaceVariant,
    };

/// "Owes you" / "You owe" / "Settled up".
String debtStanding(AppStrings strings, DebtDirection direction) =>
    switch (direction) {
      DebtDirection.owedToMe => strings.owesYou,
      DebtDirection.iOwe => strings.youOwe,
      DebtDirection.settled => strings.settledUp,
    };

/// "Sara owes you" / "You owe Sara" / "All settled up with Sara".
String debtStandingWith(
  AppStrings strings,
  DebtDirection direction,
  String name,
) => switch (direction) {
  DebtDirection.owedToMe => strings.personOwesYou(name),
  DebtDirection.iOwe => strings.youOwePerson(name),
  DebtDirection.settled => strings.settledWith(name),
};

String debtTypeLabel(AppStrings strings, PersonTransactionType type) =>
    switch (type) {
      PersonTransactionType.iPaidForThem => strings.iPaidForThem,
      PersonTransactionType.theyPaidForMe => strings.theyPaidForMe,
    };

String peopleFilterLabel(AppStrings strings, PeopleFilter filter) =>
    switch (filter) {
      PeopleFilter.all => strings.filterAll,
      PeopleFilter.owedToMe => strings.filterOwedToMe,
      PeopleFilter.iOwe => strings.filterIOwe,
      PeopleFilter.settled => strings.filterSettled,
    };

/// An arrow pointing the way the money went: out of the user's pocket when
/// they paid, into it when the person did.
IconData debtTypeIcon(PersonTransactionType type) => switch (type) {
  PersonTransactionType.iPaidForThem => Icons.north_east_rounded,
  PersonTransactionType.theyPaidForMe => Icons.south_west_rounded,
};

/// What a transaction does to the balance: the user paying for someone
/// makes them owe more (green), the reverse makes the user owe more (red).
DebtDirection debtTypeDirection(PersonTransactionType type) => switch (type) {
  PersonTransactionType.iPaidForThem => DebtDirection.owedToMe,
  PersonTransactionType.theyPaidForMe => DebtDirection.iOwe,
};
