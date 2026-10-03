import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/budget_status.dart';

sealed class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

final class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

final class BudgetReady extends BudgetState {
  const BudgetReady(this.status);

  final BudgetStatus status;

  @override
  List<Object?> get props => [status];
}

final class BudgetLoadFailure extends BudgetState {
  const BudgetLoadFailure(this.error);

  final FailureCode error;

  @override
  List<Object?> get props => [error];
}
