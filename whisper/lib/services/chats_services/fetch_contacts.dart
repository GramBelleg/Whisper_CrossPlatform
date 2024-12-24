import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/url.dart';
import 'package:whisper/models/contact.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/constants/ip_for_services.dart';

Future<List<Contact>> fetchUserContacts() async {
  final String url = domain_name; // Adjust IP address or endpoint as needed
  String? token =
      await getToken(); // Retrieve the token from shared preferences

  final response = await http.get(
    Uri.parse('$url/user/contact'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<dynamic> users = data['users'];
    // Loop through the users
    for (var user in users) {
      // Check if profilePic is null, and set default value if so
      user['profilePic'] = user['profilePic'] != null
          ? await generatePresignedUrl(user['profilePic'])
          : 'https://ui-avatars.com/api/?background=8d6aee&size=100&color=fff&name=${formatName(user['userName'])}'; // Use a default image path or URL

      print('User: ${user['userName']}');
      print('Profile Pic: ${user['profilePic']}');
    }
    print("contact here $data");

    // Convert the fetched data into a list of Contact objects
    return users.map((userData) {
      return Contact(
        userName: userData['userName'],
        profilePic: userData['profilePic'],
        userId: userData['id'],
      );
    }).toList();
  } else {
    throw Exception('Failed to load contacts');
  }
}
