import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:whisper/validators/form-validation/validate_number_field.dart';

void main() {
  group('ValidateNumberField', () {
    test('Empty Number', () {
      final result = validateNumberField(null);
      expect(result, 'This field is required');
    });

    test('Valid US Number', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+1', // US country code
        number: '1234567890',
        countryISOCode: 'US',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, null);
    });

    test('Invalid US Number (non-numeric)', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+1',
        number: '123abc456',
        countryISOCode: 'US',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, 'Only numeric values are allowed');
    });

    test('Invalid Indian Number (too short)', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+91', // India country code
        number: '123456789',
        countryISOCode: 'IN',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, 'Invalid phone number');
    });

    test('Valid Indian Number', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+91',
        number: '9876543210',
        countryISOCode: 'IN',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, null);
    });

    test('Valid Egyptian Number', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+20',
        number: '1234567890',
        countryISOCode: 'EG',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, null);
    });

    test('Invalid Egyptian Number (non-numeric)', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+20',
        number: '123abc456',
        countryISOCode: 'EG',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, 'Only numeric values are allowed');
    });

    test('Invalid Egyptian Number (too short)', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+20',
        number: '1234567',
        countryISOCode: 'EG',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, 'Invalid phone number');
    });

    test('Invalid British Number (too short)', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+44',
        number: '79111',
        countryISOCode: 'GB',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, 'Invalid phone number');
    });

    test('Valid Canadian Number', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+1',
        number: '4161234567',
        countryISOCode: 'CA',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, null);
    });

    test('Invalid Canadian Number (non-numeric)', () {
      final phoneNumber = PhoneNumber(
        countryCode: '+1',
        number: '416abc4567',
        countryISOCode: 'CA',
      );
      final result = validateNumberField(phoneNumber);
      expect(result, 'Only numeric values are allowed');
    });
  });
}
