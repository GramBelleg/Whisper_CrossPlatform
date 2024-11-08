import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';
import '../constants/ip-for-services.dart';

// Private method to handle the update API request
Future<bool> verifyEmailCode(String field, String email, String code) async {
  String? token = await GetToken();
  final url = Uri.parse(
      'http://$ip/api/user/email'); // Your update API endpoint

  // Ensure token is not null before making the request
  if (token == null) {
    print('Token is null, cannot update user field.');
    return false; // Indicate failure
  }

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({field: email, "code": code}),
    );

    if (response.statusCode == 200) {
      print("done                " + email);
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
