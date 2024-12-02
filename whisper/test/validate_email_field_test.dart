import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/validate_name_field.dart';

void main() {
  group('ValidateEmailField', () {
    test('returns error if name has special characters', () {
      expect(
        validateNameField("Seif Mohamed@"),
        'Enter a valid name',
      );
    });
    test('returns error if name has special characters', () {
      expect(
        validateNameField(""),
        'This field is required',
      );
    });
    test('valid name', () {
      expect(
        validateNameField("Seif Mohamed"),
        null,
      );
    });

    test('returns error if there is a sequence of characters more than two',
        () {
      expect(
        validateNameField("Ssseif Mohamed"),
        "Provide your real name please",
      );
    });

    test(
        'returns error if there is a sequence of special characters in the name',
        () {
      expect(
        validateNameField("Seif @@@@"),
        "Enter a valid name",
      );
    });
    test('returns error if there is a number in the name', () {
      expect(
        validateNameField("x2 y"),
        "Write your first and last names please",
      );
    });

    test('returns error if it is not a first and last name', () {
      expect(
        validateNameField("x y"),
        "Write your first and last names please",
      );
    });
    test('returns error if it is not a first and last name', () {
      expect(
        validateNameField("xy"),
        "Please provide both first and last names",
      );
    });
  });
}
