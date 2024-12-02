import 'package:flutter/material.dart';

class CustomPhoneController extends TextEditingController {
  String _countryCode = '';
  String _phoneNumber = '';

  // Set the initial country code
  void setCountryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  // Set the phone number
  void setPhoneNumber(String number) {
    _phoneNumber = number;
    text = number;
    notifyListeners();
  }

  String getFullPhoneNumber() {
    return '$_countryCode-$_phoneNumber';
  }

  String get countryCode => _countryCode;

  // Getter for phone number
  String get phoneNumber => _phoneNumber;

  @override
  set text(String newText) {
    _phoneNumber = newText;
    super.text = newText;
  }
}
