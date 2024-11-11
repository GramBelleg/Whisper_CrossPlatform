String? ValidateConfirmationCode(String? data) {
  if (data == null || data.isEmpty) {
    return 'This Field is required';
  }
  if (data.length < 8) return 'Confirmation length is at least 8';

  return null;
}
