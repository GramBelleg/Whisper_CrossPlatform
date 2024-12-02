String? ValidateEmailField(String? data) {
  if (data == null || data.isEmpty) {
    return 'This field is required';
  }

  if (data.length > 50) {
    return 'Email cannot exceed 50 characters';
  }

  final emailRegex = RegExp(
      r'^(?!.*\.\.)(?!.*\.$)(?!^\.)([a-zA-Z0-9._%+-]+)(?<!\.)@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (!emailRegex.hasMatch(data)) {
    return 'Enter a valid email';
  }

  return null; // Email is valid
}
