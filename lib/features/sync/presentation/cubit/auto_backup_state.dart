import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

sealed class AutoBackupState extends Equatable {
  const AutoBackupState();

  @override
  List<Object?> get props => [];
}

final class AutoBackupLoading extends AutoBackupState {
  const AutoBackupLoading();
}

final class AutoBackupReady extends AutoBackupState {
  const AutoBackupReady({required this.enabled, this.error});

  final bool enabled;

  /// Why the last change could not be saved; the previous choice stays.
  final FailureCode? error;

  @override
  List<Object?> get props => [enabled, error];
}
