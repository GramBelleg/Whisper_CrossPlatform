bool validateRePassword(String? password, String? rePassword) {
  if (password != rePassword) {
    return false;
  }
  return true;
}
