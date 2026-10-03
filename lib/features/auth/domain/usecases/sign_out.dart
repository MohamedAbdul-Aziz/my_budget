import '../../../../core/error/api_result.dart';
import '../repositories/auth_repository.dart';

class SignOut {
  const SignOut(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call() => _repository.signOut();
}
