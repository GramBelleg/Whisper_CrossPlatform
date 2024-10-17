import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../controllers/phone-number-controller.dart';

import '../constants/colors.dart';
import '../validators/form-validation/phone-field-validation.dart';

class CustomPhoneField extends StatefulWidget {
  const CustomPhoneField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CustomPhoneController controller;

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  @override
  void initState() {
    super.initState();
    widget.controller.setCountryCode('+20');
    widget.controller.setPhoneNumber('1');
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: widget.controller,
      style: TextStyle(
        color: secondNeutralColor,
      ),
      onChanged: (phone) {
        widget.controller.setCountryCode(phone.countryCode);
        widget.controller.setPhoneNumber(phone.number);
      },
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
      validator: ValidateNumberField,
    );
  }
}
