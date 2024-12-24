import 'package:flutter/material.dart';
import 'package:whisper/pages/view_profile_image.dart';

import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';

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

bool isValidUrl(String? profilePic) {
  if (profilePic == null || profilePic.isEmpty) return false;

  try {
    final uri = Uri.parse(profilePic);
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  } catch (e) {
    return false;
  }
}

void viewProfilePhoto(BuildContext context, String? photoUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenPhotoScreen(photoUrl: photoUrl!),
    ),
  );
}

Future<String?> loadImageUrl(String blobName) async {
  String? savedImageUrl = await getImageUrl(blobName);
  if (savedImageUrl != null) {
    return savedImageUrl;
  } else {
    return await generateAndSaveImageUrl(blobName);
  }
}

Future<String?> generateAndSaveImageUrl(String blobName) async {
  try {
    print("blobName:$blobName");
    String url = await generatePresignedUrl(blobName);
    await saveImageUrl(blobName, url);
    return url;
  } catch (e) {
    print('Error generating or saving image URL: $e');
  }
}
