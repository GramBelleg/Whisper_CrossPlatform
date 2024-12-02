bool ValidateSimilarPasswords(
  String? firstPassword,
  String? secondPassword,
) {
  if (firstPassword != secondPassword) return false;
  return true;
}
