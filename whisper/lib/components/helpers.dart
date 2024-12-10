import 'package:flutter/material.dart';
import 'package:whisper/pages/view_profile_image.dart';

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

bool isValidUrl(String str) {
  final urlPattern = r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$';
  final result = RegExp(urlPattern).hasMatch(str);
  return result;
}

void viewProfilePhoto(BuildContext context, String photoUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenPhotoScreen(photoUrl: photoUrl),
    ),
  );
}
