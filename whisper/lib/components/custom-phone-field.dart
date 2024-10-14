import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:whisper/validators/form-validation/phone-field-validation.dart';

import '../constants/colors.dart';

class CustomPhoneField extends StatefulWidget {
  const CustomPhoneField({super.key});

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      style: TextStyle(
        color: secondNeutralColor,
      ),
      disableLengthCheck: false,
      dropdownTextStyle: TextStyle(
        color: secondNeutralColor,
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: highlightColor,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: highlightColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: highlightColor,
          ),
        ),
        filled: true,
        fillColor: primaryColor,
        hintText: 'Phone Number',
        hintStyle: TextStyle(
          color: secondNeutralColor.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(),
        ),
      ),
      initialCountryCode: 'EG',
      initialValue: '1',
      validator: ValidateNumberField,
    );
  }
}
