import 'package:equatable/equatable.dart';

/// Someone signed in to a MyBudget account.
class AppUser extends Equatable {
  const AppUser({required this.id, required this.email});

  final String id;
  final String email;

  @override
  List<Object?> get props => [id, email];
}
