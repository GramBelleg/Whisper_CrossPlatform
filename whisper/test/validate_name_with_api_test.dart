import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/validate_name_wih_api.dart';

void main() {
  group('ValidateEmailField', () {
    test('returns error if name has special characters', () async {
      NameValidationResult result =
          await validateNameWithAPI("asbdahb asbjdkhasdh");
      expect(
        result.message,
        'RANDOM_TYPING',
      );
    });

    test('returns error if name has special characters', () async {
      NameValidationResult result =
          await validateNameWithAPI("SEifffff Mohammmed");
      expect(
        result.message,
        'RANDOM_TYPING',
      );
    });
  });
}
