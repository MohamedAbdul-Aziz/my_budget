import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  AppUser? call() => _repository.currentUser;
}
