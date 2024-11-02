import 'package:intl_phone_field/phone_number.dart';

String? ValidateNumberField(PhoneNumber? data) {
  if (data == null || data.number.isEmpty) {
    return 'This field is required';
  }

  if (!RegExp(r'^\d+$').hasMatch(data.number)) {
    return 'Only numeric values are allowed';
  }

  return null;
}
