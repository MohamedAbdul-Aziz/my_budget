import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/debt_balance.dart';
import '../../domain/entities/people_filter.dart';
import '../../domain/entities/person_summary.dart';

sealed class PeopleState extends Equatable {
  const PeopleState();

  @override
  List<Object?> get props => [];
}

final class PeopleLoading extends PeopleState {
  const PeopleLoading();
}

final class PeopleLoadFailure extends PeopleState {
  const PeopleLoadFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class PeopleReady extends PeopleState {
  const PeopleReady({
    required this.people,
    this.filter = PeopleFilter.all,
    this.notice,
  });

  /// Everyone, alphabetical.
  final List<PersonSummary> people;
  final PeopleFilter filter;

  /// Set for one emission after a change or an error.
  final UiNotice? notice;

  List<PersonSummary> get visible => [
    for (final summary in people)
      if (filter.matches(summary)) summary,
  ];

  /// What everyone owes the user.
  DebtBalance get owedToMe => DebtBalance.cents(
    people.fold(
      0,
      (sum, p) => p.balance.cents > 0 ? sum + p.balance.cents : sum,
    ),
  );

  /// What the user owes everyone, as a positive amount.
  DebtBalance get iOwe => DebtBalance.cents(
    people.fold(
      0,
      (sum, p) => p.balance.cents < 0 ? sum - p.balance.cents : sum,
    ),
  );

  PeopleReady copyWith({
    List<PersonSummary>? people,
    PeopleFilter? filter,
    UiNotice? notice,
  }) => PeopleReady(
    people: people ?? this.people,
    filter: filter ?? this.filter,
    notice: notice,
  );

  @override
  List<Object?> get props => [people, filter, notice];
}
