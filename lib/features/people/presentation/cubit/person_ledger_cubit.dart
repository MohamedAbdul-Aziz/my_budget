import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../core/utils/ui_notice.dart';
import '../../domain/entities/person_transaction.dart';
import '../../domain/entities/person_transaction_type.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/usecases/add_person_transaction.dart';
import '../../domain/usecases/delete_person_transaction.dart';
import '../../domain/usecases/get_person_ledger.dart';
import '../../domain/usecases/log_settlement_to_budget.dart';
import '../../domain/usecases/settle_up.dart';
import '../../domain/usecases/update_person.dart';
import '../../domain/usecases/update_person_transaction.dart';
import 'person_ledger_state.dart';

/// One instance per ledger screen: everything recorded with one person, and
/// the changes made there.
class PersonLedgerCubit extends Cubit<PersonLedgerState> {
  PersonLedgerCubit({
    required GetPersonLedger getPersonLedger,
    required UpdatePerson updatePerson,
    required AddPersonTransaction addPersonTransaction,
    required UpdatePersonTransaction updatePersonTransaction,
    required DeletePersonTransaction deletePersonTransaction,
    required SettleUp settleUp,
    required LogSettlementToBudget logSettlementToBudget,
  }) : _getPersonLedger = getPersonLedger,
       _updatePerson = updatePerson,
       _addPersonTransaction = addPersonTransaction,
       _updatePersonTransaction = updatePersonTransaction,
       _deletePersonTransaction = deletePersonTransaction,
       _settleUp = settleUp,
       _logSettlementToBudget = logSettlementToBudget,
       super(const PersonLedgerLoading());

  final GetPersonLedger _getPersonLedger;
  final UpdatePerson _updatePerson;
  final AddPersonTransaction _addPersonTransaction;
  final UpdatePersonTransaction _updatePersonTransaction;
  final DeletePersonTransaction _deletePersonTransaction;
  final SettleUp _settleUp;
  final LogSettlementToBudget _logSettlementToBudget;

  late String _personId;

  Future<void> load(String personId) async {
    _personId = personId;
    emit(const PersonLedgerLoading());
    await _fetch();
  }

  /// Returns why the change was refused, or null once it is saved.
  Future<FailureCode?> editPerson({
    required String name,
    required int colorValue,
    String? phone,
  }) async {
    final current = state;
    if (current is! PersonLedgerReady) return FailureCode.notFound;
    final result = await _updatePerson(
      current.ledger.person,
      name: name,
      colorValue: colorValue,
      phone: phone,
    );
    return _afterChange(
      result,
      success: UiNotice(NoticeCode.personUpdated),
      inSheet: true,
    );
  }

  /// Returns why the transaction was refused, or null once it is saved.
  Future<FailureCode?> addTransaction({
    required String amountText,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) async {
    final amount = AmountInput.parse(amountText);
    if (amount == null) return FailureCode.amountInvalid;
    final result = await _addPersonTransaction(
      personId: _personId,
      amount: amount,
      type: type,
      date: date,
      note: note,
    );
    return _afterChange(result, inSheet: true);
  }

  /// Returns why the edit was refused, or null once it is saved.
  Future<FailureCode?> editTransaction(
    PersonTransaction existing, {
    required String amountText,
    required PersonTransactionType type,
    required DateTime date,
    String? note,
  }) async {
    final amount = AmountInput.parse(amountText);
    if (amount == null) return FailureCode.amountInvalid;
    final result = await _updatePersonTransaction(
      existing,
      amount: amount,
      type: type,
      date: date,
      note: note,
    );
    return _afterChange(result, inSheet: true);
  }

  Future<void> deleteTransaction(PersonTransaction transaction) async {
    final result = await _deletePersonTransaction(transaction);
    await _afterChange(result, success: UiNotice(NoticeCode.debtDeleted));
  }

  /// Settles every open transaction. Returns the settlement, so the user can
  /// be asked whether to log it in the budget, or null when it failed.
  Future<Settlement?> settleUp() async {
    final result = await _settleUp(_personId);
    await _afterChange(result, success: UiNotice(NoticeCode.settledUp));
    return result.dataOrNull;
  }

  /// Logs [settlement] in the monthly budget. Returns whether it was.
  Future<bool> logToBudget(
    Settlement settlement, {
    required String description,
  }) async {
    final result = await _logSettlementToBudget(
      settlement,
      description: description,
    );
    final failure = await _afterChange(
      result,
      success: UiNotice(NoticeCode.settlementLogged),
    );
    return failure == null;
  }

  /// Reloads after a successful change and shows [success]. A failure is
  /// returned, and also shown as a notice unless the change came from a
  /// sheet, which keeps the reason on screen itself.
  Future<FailureCode?> _afterChange(
    ApiResult<Object?> result, {
    UiNotice? success,
    bool inSheet = false,
  }) async {
    final failure = result.failureOrNull;
    if (failure == null) {
      await _fetch(notice: success);
      return null;
    }
    final current = state;
    if (!inSheet && current is PersonLedgerReady) {
      emit(
        PersonLedgerReady(
          ledger: current.ledger,
          notice: UiNotice.from(failure),
        ),
      );
    }
    return failure.code;
  }

  Future<void> _fetch({UiNotice? notice}) async {
    final result = await _getPersonLedger(_personId);
    switch (result) {
      case Success(:final data):
        emit(PersonLedgerReady(ledger: data, notice: notice));
      case ResultFailure(:final failure):
        emit(PersonLedgerLoadFailure(failure));
    }
  }
}
