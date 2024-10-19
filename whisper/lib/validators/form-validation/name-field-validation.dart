String? ValidateNameField(String? data) {
  if (data == null || data.isEmpty) {
    return 'This Field is required';
  }
  return null;
}
