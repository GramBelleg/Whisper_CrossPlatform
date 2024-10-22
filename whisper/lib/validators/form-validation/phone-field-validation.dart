import 'package:intl_phone_field/phone_number.dart';

String? ValidateNumberField(PhoneNumber? data) {
  if (data == null || data.number.isEmpty) {
    return 'This Field is required';
  }
  return null;
}
