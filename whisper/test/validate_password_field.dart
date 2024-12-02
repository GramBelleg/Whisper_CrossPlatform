import 'package:flutter_test/flutter_test.dart';
import 'package:whisper/validators/form-validation/validate_passward_field.dart';

void main() {
  group('validatePasswordField', () {
    test('returns error if password is null', () {
      expect(validatePasswordField(null), 'This field is required');
    });

    test('returns error if password is empty', () {
      expect(validatePasswordField(''), 'This field is required');
    });

    test('returns error if password is too short', () {
      expect(validatePasswordField('Ab1@'),
          'Password must be at least 6 characters');
    });

    test('returns error if password exceeds max length', () {
      expect(validatePasswordField('A1b@' * 6),
          'Password must not exceed 20 characters');
    });

    test('returns error if password has no lowercase letters', () {
      expect(validatePasswordField('ABC123@'),
          'Password must contain at least one lowercase letter');
    });

    test('returns error if password has no uppercase letters', () {
      expect(validatePasswordField('abc123@'),
          'Password must contain at least one uppercase letter');
    });

    test('returns error if password has no digits', () {
      expect(validatePasswordField('Abcdef@'),
          'Password must contain at least one digit');
    });

    test('returns error if password has no special characters', () {
      expect(validatePasswordField('Abc1234'),
          'Password must contain at least one special character (@,\$, !, %, *, ?, &)');
    });
    test('valid password', () {
      expect(validatePasswordField('Abc_1234'), null);
    });

    test(
        'returns error if password has too many consecutive repeating characters',
        () {
      expect(validatePasswordField('Aaaa1@bc'),
          'Password must not contain more than 3 consecutive repeating characters');
    });

    test('returns null for a valid password', () {
      expect(validatePasswordField('Valid@123'), null);
    });

    test('returns null for a valid password', () {
      expect(validatePasswordField('Valvvd@123vv'), null);
    });
  });
}
