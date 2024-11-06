import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';

void main() {
  group('ValidateEmailField', () {
    test('returns error if email is null', () {
      expect(ValidateEmailField(null), 'This field is required');
    });

    test('returns error if email is empty', () {
      expect(ValidateEmailField(''), 'This field is required');
    });

    test('returns error for invalid email without "@"', () {
      expect(ValidateEmailField('example.com'), 'Enter a valid email');
    });

    test('returns error for invalid email with multiple "@"', () {
      expect(ValidateEmailField('user@@example.com'), 'Enter a valid email');
    });

    test('returns error for invalid email without domain', () {
      expect(ValidateEmailField('user@.com'), 'Enter a valid email');
    });
    test('returns error for invalid email starts with dot', () {
      expect(ValidateEmailField('.user@.com'), 'Enter a valid email');
    });
    test('returns error for invalid email ends with dot', () {
      expect(ValidateEmailField('user@.com.'), 'Enter a valid email');
    });
    test('returns error for invalid email contains consecutive dots', () {
      expect(ValidateEmailField('user@gmail..com'), 'Enter a valid email');
    });

    test('returns error for invalid email with invalid characters', () {
      expect(ValidateEmailField('user@exa!mple.com'), 'Enter a valid email');
    });

    test('returns error for valid email but invalid TLD', () {
      expect(ValidateEmailField('user@example.c'), 'Enter a valid email');
    });

    test('returns valid for a correctly formatted email', () {
      expect(ValidateEmailField('user@example.com'), null);
    });

    test('returns valid for email with subdomain', () {
      expect(ValidateEmailField('user@mail.example.com'), null);
    });

    test('returns valid for email with numbers and special characters', () {
      expect(ValidateEmailField('user.name+tag@example.co.uk'), null);
    });

  });
}
