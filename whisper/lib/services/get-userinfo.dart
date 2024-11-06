import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/components/user-state.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<UserState?> fetchUserInfo() async {
  final url =
      Uri.parse('http://192.168.1.11:5000/api/user/info'); // API endpoint
  String? token = await GetToken(); // Retrieve token

  if (token == null) {
    print('Token is null, cannot fetch user info.');
    return null; // Handle this case as needed
  }

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body) ?? {}; // Access 'data' key safely
      print('User Info: $data');

      // Create and return a UserState object with all fields, handling null values
      return UserState(
        name: data['name'] ?? 'Unknown',
        username: data['userName'] ?? 'unknown_user',
        email: data['email'] ?? 'No email',
        bio: data['bio'] ?? '',
        profilePic: data['profilePic'] ?? '',
        lastSeen: data['lastSeen'] ?? '',
        status: data['status'] ?? 'offline',
        phoneNumber: data['phoneNumber'] ?? 'Not provided',
        autoDownloadSize: data['autoDownloadSize'] ?? 0,
        lastSeenPrivacy: data['lastSeenPrivacy'] ?? 'default',
        pfpPrivacy: data['pfpPrivacy'] ?? 'default',
        readReceipts: data['readReceipts'] ?? false,
      );
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      return null; // Handle error cases as needed
    }
  } catch (e) {
    print('Something went wrong: $e');
    print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
    return null; // Handle error cases as needed
  }
}
