String? ValidatePasswordField(String? value) {
  if (value == null || value.isEmpty) {
    return 'This Field is required';
  } else if (value.length < 0) {
    return 'Password must be at least 8 characters';
  }
  return null;
}
