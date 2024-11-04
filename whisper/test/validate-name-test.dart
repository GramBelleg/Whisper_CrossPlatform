import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/name-field-validation.dart';

void main() {
  group('ValidateEmailField', () {
    test('returns error if name has special characters', () {
      expect(
        ValidateNameField("Seif Mohamed@"),
        'Enter a valid name',
      );
    });
    test('returns error if name has special characters', () {
      expect(
        ValidateNameField(""),
        'This field is required',
      );
    });
    test('valid name', () {
      expect(
        ValidateNameField("Seif Mohamed"),
        null,
      );
    });

    test('returns error if there is a sequence of characters more than two', () {
      expect(
        ValidateNameField("Ssseif Mohamed"),
        "Provide your real name please",
      );
    });

    test(
        'returns error if there is a sequence of special characters in the name',
        () {
      expect(
        ValidateNameField("Seif @@@@"),
        "Enter a valid name",
      );
    });
    test('returns error if there is a number in the name', () {
      expect(
        ValidateNameField("x2 y"),
        "Write your first and last names please",
      );
    });

    test('returns error if it is not a first and last name', () {
      expect(
        ValidateNameField("x y"),
        "Write your first and last names please",
      );
    });
    test('returns error if it is not a first and last name', () {
      expect(
        ValidateNameField("xy"),
        "Please provide both first and last names",
      );
    });
  });
}
