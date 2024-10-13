String? ValidateEmailField(String? data) {
  if (data == null || data.isEmpty) {
    return 'This Field is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(data)) {
    return 'Enter a valid email';
  }
  return null;
}
