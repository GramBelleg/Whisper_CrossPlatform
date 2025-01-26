import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';

Future<List<dynamic>> fetchAddableUsers(int chatId) async {
  final String url = '$ip/chats/$chatId/addableUsers';
  String? token = await getToken();

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Response status code: ${response.body}");
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> addableUsers = responseData['users'] ?? [];
      print("Addable Users: $addableUsers");
      return addableUsers;
    } else {
      throw Exception('Failed to load addable users');
    }
  } catch (e) {
    print('Error fetching addable users: $e');
    return [];
  }
}
