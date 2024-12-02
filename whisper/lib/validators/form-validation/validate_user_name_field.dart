String? validateUsernameField(String? username) {
  if (username == null || username.isEmpty) {
    return 'This field is required';
  }

  if (username.length < 6) {
    return 'username should be at least 6 characters';
  }
  if (username.length > 15) {
    return 'username should be at most 15 characters';
  }
  final usernameRegex = RegExp(r'^[\w\s!@#$%^&*()\-=+<>?]{1,50}$');
  if (!usernameRegex.hasMatch(username)) {
    return 'Enter a valid username';
  }

  return null; // Username is valid
}
