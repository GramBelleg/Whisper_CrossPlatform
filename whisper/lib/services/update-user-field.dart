import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

// Private method to handle the update API request
Future<bool> updateUserField(String field, String value) async {
  String? token = await GetToken();
  final url = Uri.parse(
      'http://172.20.192.1:5000/api/user/$field'); // Your update API endpoint

  // Ensure token is not null before making the request
  if (token == null) {
    print('Token is null, cannot update user field.');
    return false; // Indicate failure
  }

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        field: value,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Indicate success
    } else {
      print('Update failed: ${response.statusCode}, ${response.body}');
      return false; // Indicate failure
    }
  } catch (e) {
    print('Error updating user field: $e');
    return false; // Indicate failure
  }
}
