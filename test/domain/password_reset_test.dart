import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/auth/domain/usecases/reset_password.dart';
import 'package:my_budget/features/auth/domain/usecases/send_password_reset.dart';

import '../presentation/fakes.dart';

void main() {
  late FakeAuthRepository auth;

  setUp(() {
    auth = FakeAuthRepository()
      ..addConfirmedAccount('mohamed@example.com', 'old-secret');
  });

  group('SendPasswordReset', () {
    test('ignores case and surrounding spaces', () async {
      final result = await SendPasswordReset(auth)(
        email: ' Mohamed@Example.com ',
      );

      expect(result.isSuccess, isTrue);
      expect(auth.resetCodes.keys, ['mohamed@example.com']);
    });

    test('rejects text that is not an email address', () async {
      final result = await SendPasswordReset(auth)(email: 'mohamed');

      expect(result.failureOrNull?.code, FailureCode.emailInvalid);
      expect(auth.resetCodes, isEmpty);
    });
  });

  group('ResetPassword', () {
    setUp(() => SendPasswordReset(auth)(email: 'mohamed@example.com'));

    Future<ApiResult<void>> reset(String code, String newPassword) =>
        ResetPassword(auth)(
          email: 'mohamed@example.com',
          code: code,
          newPassword: newPassword,
        );

    test('the emailed code saves the new password and signs in', () async {
      final result = await reset(' 111111 ', 'new-secret');

      expect(result.isSuccess, isTrue);
      expect(auth.passwords['mohamed@example.com'], 'new-secret');
      expect(auth.currentUser?.email, 'mohamed@example.com');
    });

    test('a short password is refused before the code is used', () async {
      final result = await reset('111111', '12345');

      expect(result.failureOrNull?.code, FailureCode.passwordTooShort);
      // Checking the code would already sign the user in.
      expect(auth.currentUser, isNull);
      expect(auth.resetCodes['mohamed@example.com'], '111111');
    });

    test('rejects a code that is not digits', () async {
      final result = await reset('abc', 'new-secret');

      expect(result.failureOrNull?.code, FailureCode.codeInvalid);
      expect(auth.passwords['mohamed@example.com'], 'old-secret');
    });

    test('a wrong code changes nothing', () async {
      final result = await reset('999999', 'new-secret');

      expect(result.failureOrNull?.code, FailureCode.codeInvalid);
      expect(auth.passwords['mohamed@example.com'], 'old-secret');
      expect(auth.currentUser, isNull);
    });
  });
}
