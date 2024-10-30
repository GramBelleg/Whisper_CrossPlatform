import 'dart:convert';

import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/name-field-validation.dart';
import 'package:whisper/validators/form-validation/validate-name-with-api.dart';

void main() {
  group('ValidateEmailField', () {

    test('returns error if name has special characters', () async{
      NameValidationResult result = await ValidateNameWithAPI("asbdahb asbjdkhasdh");
      expect(
        result.message,
        'RANDOM_TYPING',
      );
    });

    test('returns error if name has special characters', () async{
      NameValidationResult result = await ValidateNameWithAPI("SEiff Mohammmed");
      expect(
        result.message,
        'RANDOM_TYPING',
      );
    });
  });
}
