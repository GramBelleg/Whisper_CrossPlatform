String formatName(String fullName) {
  List<String> names = fullName.split(" ");

  if (names.length > 1) {
    // Get the first and last name
    return "${names[0]}+${names[names.length - 1]}";
  } else {
    // If only one name is present, return as is
    return fullName;
  }
}
