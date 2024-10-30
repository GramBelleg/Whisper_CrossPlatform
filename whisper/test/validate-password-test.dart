import 'package:flutter_test/flutter_test.dart';
import 'package:whisper/validators/form-validation/password-field-validation.dart';

void main() {
  group('validatePasswordField', () {
    test('returns error if password is null', () {
      expect(ValidatePasswordField(null), 'This field is required');
    });

    test('returns error if password is empty', () {
      expect(ValidatePasswordField(''), 'This field is required');
    });

    test('returns error if password is too short', () {
      expect(ValidatePasswordField('Ab1@'),
          'Password must be at least 6 characters');
    });

    test('returns error if password exceeds max length', () {
      expect(ValidatePasswordField('A1b@' * 6),
          'Password must not exceed 20 characters');
    });

    test('returns error if password has no lowercase letters', () {
      expect(ValidatePasswordField('ABC123@'),
          'Password must contain at least one lowercase letter');
    });

    test('returns error if password has no uppercase letters', () {
      expect(ValidatePasswordField('abc123@'),
          'Password must contain at least one uppercase letter');
    });

    test('returns error if password has no digits', () {
      expect(ValidatePasswordField('Abcdef@'),
          'Password must contain at least one digit');
    });

    test('returns error if password has no special characters', () {
      expect(ValidatePasswordField('Abc1234'),
          'Password must contain at least one special character (@,\$, !, %, *, ?, &)');
    });

    test(
        'returns error if password has too many consecutive repeating characters',
        () {
      expect(ValidatePasswordField('Aaaa1@bc'),
          'Password must not contain more than 3 consecutive repeating characters');
    });

    test('returns null for a valid password', () {
      expect(ValidatePasswordField('Valid@123'), null);
    });

    test('returns null for a valid password', () {
      expect(ValidatePasswordField('Valvvd@123vv'), null);
    });
  });
}
