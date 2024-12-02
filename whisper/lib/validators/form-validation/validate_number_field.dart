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
