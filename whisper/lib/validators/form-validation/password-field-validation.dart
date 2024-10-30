String? ValidatePasswordField(String? value,
    {int minLength = 6, int maxLength = 20, int maxRepeat = 3}) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value.contains(" ")) {
    return 'Password must not contain spaces';
  }

  String passwordWithoutSpaces = value.replaceAll(" ", "");

  if (passwordWithoutSpaces.length < minLength) {
    return 'Password must be at least $minLength characters';
  } else if (passwordWithoutSpaces.length > maxLength) {
    return 'Password must not exceed $maxLength characters';
  }

  final hasLower = RegExp(r'[a-z]').hasMatch(passwordWithoutSpaces);
  final hasUpper = RegExp(r'[A-Z]').hasMatch(passwordWithoutSpaces);
  final hasDigit = RegExp(r'\d').hasMatch(passwordWithoutSpaces);
  final hasSpecialChar = RegExp(r'[@$!%*?&#^]').hasMatch(passwordWithoutSpaces);
  final repeatPattern = RegExp(r'(.)\1{' + (maxRepeat-1).toString() + ',}');

  if (!hasLower) {
    return 'Password must contain at least one lowercase letter';
  } else if (!hasUpper) {
    return 'Password must contain at least one uppercase letter';
  } else if (!hasDigit) {
    return 'Password must contain at least one digit';
  } else if (!hasSpecialChar) {
    return 'Password must contain at least one special character (@,\$, !, %, *, ?, &)';
  } else if (repeatPattern.hasMatch(passwordWithoutSpaces)) {
    return 'Password must not contain more than $maxRepeat consecutive repeating characters';
  }

  return null; // Password is valid
}
