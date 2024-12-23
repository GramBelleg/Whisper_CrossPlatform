import 'package:whisper/validators/form-validation/longest_repteated_letter.dart';

String? validateNameField(String? data) {
  if (data == null || data.isEmpty) {
    return 'name is required';
  }
  if (data.length > 50) {
    return 'name should be at most 50 characters';
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

  final longestRepeatedLetters = longestRepeatedLetter(data);
  if (longestRepeatedLetters != '') {
    return "Provide your real name please";
  }

  return null; // Name is valid
}
