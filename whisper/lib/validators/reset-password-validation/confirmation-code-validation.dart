String? ValidateConfirmationCode(String? data) {
  if (data == null || data.isEmpty) {
    return 'This Field is required';
  }
  if (data.length < 6) return 'Confirmation length is at least 6';

  return null;
}
