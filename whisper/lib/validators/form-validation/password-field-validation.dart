String? ValidatePasswordField(String? value, {int minLength = 6, int maxLength = 20, int maxRepeat = 2}) {
  String? tempValue = value?.replaceAll(" ", "");

  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (tempValue!.length < minLength) {
    return 'Password must be at least $minLength characters';
  } else if (tempValue.length > maxLength) {
    return 'Password must not exceed $maxLength characters';
  }

  final hasLower = RegExp(r'[a-z]').hasMatch(tempValue);
  final hasUpper = RegExp(r'[A-Z]').hasMatch(tempValue);
  final hasDigit = RegExp(r'\d').hasMatch(tempValue);
  final repeatPattern = RegExp(r'(.)\1{' + maxRepeat.toString() + ',}');

  if (!hasLower) {
    return 'Password must contain at least one lowercase letter';
  } else if (!hasUpper) {
    return 'Password must contain at least one uppercase letter';
  } else if (!hasDigit) {
    return 'Password must contain at least one digit';
  } else if (repeatPattern.hasMatch(tempValue)) {
    return 'Password must not contain more than $maxRepeat consecutive repeating characters';
  }

  return null;
}
