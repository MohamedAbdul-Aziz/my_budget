import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/people_filter.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_transaction_type.dart';
import '../../domain/usecases/add_person.dart';
import '../../domain/usecases/add_person_transaction.dart';
import '../../domain/usecases/delete_person.dart';
import '../../domain/usecases/get_people.dart';
import 'people_state.dart';

/// Drives the People tab: everyone with their balance, the filter, and the
/// changes made from there (adding a person, a quick transaction, deleting
/// someone).
class PeopleCubit extends Cubit<PeopleState> {
  PeopleCubit({
    required GetPeople getPeople,
    required AddPerson addPerson,
    required AddPersonTransaction addPersonTransaction,
    required DeletePerson deletePerson,
  }) : _getPeople = getPeople,
       _addPerson = addPerson,
       _addPersonTransaction = addPersonTransaction,
       _deletePerson = deletePerson,
       super(const PeopleLoading());

  final GetPeople _getPeople;
  final AddPerson _addPerson;
  final AddPersonTransaction _addPersonTransaction;
  final DeletePerson _deletePerson;

  /// First load: shows the spinner. Later calls should use [refresh].
  Future<void> load() async {
    emit(const PeopleLoading());
    await _fetch();
  }

  /// Silent reload, after a person's ledger changed.
  Future<void> refresh() => _fetch();

  void selectFilter(PeopleFilter filter) {
    final current = state;
    if (current is PeopleReady && current.filter != filter) {
      emit(current.copyWith(filter: filter));
    }
  }

  /// Returns the new person, or the reason they were refused, so the sheet
  /// can stay open with it.
  Future<ApiResult<Person>> addPerson({
    required String name,
    required int colorValue,
    String? phone,
  }) async {
    final result = await _addPerson(
      name: name,
      colorValue: colorValue,
      phone: phone,
    );
    if (result case Success(:final data)) {
      await _fetch(notice: UiNotice(NoticeCode.personAdded, name: data.name));
    }
    return result;
  }

  /// Returns why the transaction was refused, or null once it is saved.
  Future<FailureCode?> addTransaction({
    required String? personId,
    required String amountText,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) async {
    if (personId == null) return FailureCode.personRequired;
    final amount = AmountInput.parse(amountText);
    if (amount == null) return FailureCode.amountInvalid;

    final result = await _addPersonTransaction(
      personId: personId,
      amount: amount,
      type: type,
      date: date,
      note: note,
    );
    final failure = result.failureOrNull;
    if (failure == null) await _fetch();
    return failure?.code;
  }

  Future<void> deletePerson(Person person) async {
    final result = await _deletePerson(person.id);
    await _fetch(
      notice: switch (result) {
        Success() => UiNotice(NoticeCode.personDeleted, name: person.name),
        ResultFailure(:final failure) => UiNotice.from(failure),
      },
    );
  }

  Future<void> _fetch({UiNotice? notice}) async {
    final result = await _getPeople();
    final filter = switch (state) {
      PeopleReady(:final filter) => filter,
      _ => PeopleFilter.all,
    };
    switch (result) {
      case Success(:final data):
        emit(PeopleReady(people: data, filter: filter, notice: notice));
      case ResultFailure(:final failure):
        emit(PeopleLoadFailure(failure));
    }
  }
}
