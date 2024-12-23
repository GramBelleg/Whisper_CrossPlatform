import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/components/helpers.dart';
import 'package:whisper/models/user_state.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';

Future<UserState?> fetchUserInfo() async {
  final url = Uri.parse('http://$ip:5000/api/user/info'); // API endpoint
  String? token = await getToken(); // Retrieve token

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
      var data = jsonDecode(response.body) ?? {}; // Access 'data' key safely
      String? mediaUrl = data['profilePic'] != null
          ? await generatePresignedUrl(data['profilePic'])
          : 'https://ui-avatars.com/api/?background=0a122f&size=1500&color=fff&name=${formatName(data['userName'])}';
      // Create and return a UserState object with all fields, handling null values
      return UserState(
        name: data['name'] ?? 'Unknown',
        username: data['userName'] ?? 'unknown_user',
        email: data['email'] ?? 'No email',
        bio: data['bio'] ?? '',
        profilePic: mediaUrl,
        lastSeen: data['lastSeen'] ?? '',
        status: data['status'] ?? 'offline',
        phoneNumber: data['phoneNumber'].substring(1) ?? 'Not provided',
        autoDownloadSize: data['autoDownloadSize'] ?? 0,
        lastSeenPrivacy: data['lastSeenPrivacy'] ?? 'default',
        pfpPrivacy: data['pfpPrivacy'] ?? 'default',
        readReceipts: data['readReceipts'] ?? false,
        hasStory: data['hasStory'] ?? false,
      );
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      return null; // Handle error cases as needed
    }
  } catch (e) {
    print('Something went wrong: $e');
    return null; // Handle error cases as needed
  }
}

Future<Map<String, dynamic>?> fetchProfileData(int id) async {
  // Replace with your actual API endpoint
  final url = Uri.parse('http://$ip:5000/api/user/$id/info'); // API endpoint
  String? token = await getToken(); // Retrieve token

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
      var data = jsonDecode(response.body) ?? {}; // Safely parse the response
      String? mediaUrl = data['profilePic'] != null
          ? await generatePresignedUrl(data['profilePic'])
          : 'https://ui-avatars.com/api/?background=0a122f&size=1500&color=fff&name=${formatName(data['userName'])}';

      // Add the mediaUrl to the data if it's available
      data['profilePicUrl'] = mediaUrl;

      return data; // Return the data as a map
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      return null; // Handle error cases as needed
    }
  } catch (e) {
    print('Something went wrong: $e');
    return null; // Handle error cases as needed
  }
}
