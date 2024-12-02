import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/validate_email_field.dart';

void main() {
  group('ValidateEmailField', () {
    test('returns error if email is null', () {
      expect(validateEmailField(null), 'This field is required');
    });

    test('returns error if email is empty', () {
      expect(validateEmailField(''), 'This field is required');
    });

    test('returns error for invalid email without "@"', () {
      expect(validateEmailField('example.com'), 'Enter a valid email');
    });

    test('returns error for invalid email with multiple "@"', () {
      expect(validateEmailField('user@@example.com'), 'Enter a valid email');
    });

    test('returns error for invalid email without domain', () {
      expect(validateEmailField('user@.com'), 'Enter a valid email');
    });
    test('returns error for invalid email starts with dot', () {
      expect(validateEmailField('.user@.com'), 'Enter a valid email');
    });
    test('returns error for invalid email ends with dot', () {
      expect(validateEmailField('user@.com.'), 'Enter a valid email');
    });
    test('returns error for invalid email contains consecutive dots', () {
      expect(validateEmailField('user@gmail..com'), 'Enter a valid email');
    });

    test('returns error for invalid email with invalid characters', () {
      expect(validateEmailField('user@exa!mple.com'), 'Enter a valid email');
    });

    test('returns error for valid email but invalid TLD', () {
      expect(validateEmailField('user@example.c'), 'Enter a valid email');
    });

    test('returns valid for a correctly formatted email', () {
      expect(validateEmailField('user@example.com'), null);
    });

    test('returns valid for email with subdomain', () {
      expect(validateEmailField('user@mail.example.com'), null);
    });

    test('returns valid for email with numbers and special characters', () {
      expect(validateEmailField('user.name+tag@example.co.uk'), null);
    });
  });
}
