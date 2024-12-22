String? validateBioField(String? bio) {
  if (bio == null || bio.trim().isEmpty) {
    return 'Bio cannot be empty';
  }
  if (bio.length > 150) {
    return 'Bio cannot exceed 150 characters';
  }
  return null; // Bio is valid
}
