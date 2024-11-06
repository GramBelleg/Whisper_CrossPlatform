import 'package:whisper/validators/form-validation/longest-repeated-letter.dart';

String? ValidateNameField(String? data) {
  if (data == null || data.isEmpty) {
    return 'This field is required';
  }

  if (!data.contains(' ')) {
    return 'Please provide both first and last names';
  }

  if (data.length < 6) {
    return 'Write your first and last names please';
  }

  final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  if (!nameRegex.hasMatch(data)) {
    return 'Enter a valid name';
  }

  final longestRepeatedLetter = LongestRepeatedLetter(data);
  if (longestRepeatedLetter != '') {
    return "Provide your real name please";
  }

  return null; // Name is valid
}
