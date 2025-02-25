import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/url.dart';
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';

// Private method to handle the update API request
Future<Map<String, dynamic>> updateUserField(String field, String value) async {
  String? token = await getToken();
  final url =
      Uri.parse('$domain_name/user/$field'); // Your update API endpoint

  // Ensure token is not null before making the request
  if (token == null) {
    print('Token is null, cannot update user field.');
    return {
      'success': false,
      'message': 'Token is null, cannot update user field.'
    };
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
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Assuming the response contains a 'data' field with the updated value
      return {
        'success': true,
        'message': responseData['data'],
      };
    } else if (response.statusCode == 400) {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Error updating user field',
      };
    } else {
      print('Update failed: ${response.statusCode}, ${response.body}');
      return {
        'success': false,
        'message': responseData['message'],
      };
    }
  } catch (e) {
    print('Error updating user field: $e');
    return {
      'success': false,
      'message': 'Error updating user field: $e',
    };
  }
}
