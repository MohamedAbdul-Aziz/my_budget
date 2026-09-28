import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/auth/domain/usecases/sign_up.dart';

void main() {
  group('SignUp.normalizeEmail', () {
    test('ignores case and surrounding spaces', () {
      expect(
        SignUp.normalizeEmail('  Mohamed@Example.com '),
        'mohamed@example.com',
      );
    });
  });

  group('SignUp.validate', () {
    Failure? validate(String email, [String password = 'secret1']) =>
        SignUp.validate(email: email, password: password);

    test('accepts an ordinary address', () {
      expect(validate('mohamed@example.com'), isNull);
    });

    test('rejects text that is not an email address', () {
      expect(validate('mohamed')?.code, FailureCode.emailInvalid);
      expect(validate('mohamed@example')?.code, FailureCode.emailInvalid);
      expect(validate('mo hamed@example.com')?.code, FailureCode.emailInvalid);
      expect(validate('')?.code, FailureCode.emailInvalid);
    });

    test('rejects a password shorter than 6 characters', () {
      expect(
        validate('mohamed@example.com', '12345')?.code,
        FailureCode.passwordTooShort,
      );
    });
  });
}
