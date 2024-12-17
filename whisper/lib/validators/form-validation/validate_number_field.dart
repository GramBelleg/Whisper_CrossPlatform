import 'package:intl_phone_field/phone_number.dart';

String? validateNumberField(PhoneNumber? data) {
  if (data == null || data.number.isEmpty) {
    return 'This field is required';
  }

  if (!RegExp(r'^\d+$').hasMatch(data.number)) {
    return 'Only numeric values are allowed';
  }

  try {
    bool isValid = data.isValidNumber();
    if (!isValid) {
      return 'Invalid phone number';
    }
  } catch (e) {
    print('error: $e');
    return 'Invalid phone number';
  }

  return null;
}

String? validateNumberFieldString(String? number) {
  if (number == null || number.isEmpty) {
    return 'This field is required';
  }

  if (!RegExp(r'^\d+$').hasMatch(number)) {
    return 'Only numeric values are allowed';
  }

  try {
    // You can replace this with any custom validation logic for a phone number
    if (number.length < 10 || number.length > 15) {
      return 'Phone number should be between 10 and 15 digits';
    }
  } catch (e) {
    print('error: $e');
    return 'Invalid phone number';
  }

  return null; // Return null if the phone number is valid
}
