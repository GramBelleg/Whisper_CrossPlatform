import 'package:whisper/validators/form-validation/longest-repeated-letter.dart';

String? ValidateUsernameField(String? username) {
  if (username == null || username.isEmpty) {
    return 'This field is required';
  }

  if (username.length < 6) {
    return 'username should be at least 6 characters';
  }

  final usernameRegex = RegExp(r'^[\w\s!@#$%^&*()\-=+<>?]{1,50}$');
  if (!usernameRegex.hasMatch(username)) {
    return 'Enter a valid username';
  }

  return null; // Username is valid
}
