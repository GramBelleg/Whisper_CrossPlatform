import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/services/shared_preferences.dart';

Future<List<dynamic>> chatsGlobalSearch(String query) async {
  final String? token = await getToken(); // Retrieve token from secure storage
  final Uri url =
      Uri.parse('http://$ip:5000/api/chats/globalSearch?query=$query');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chats'];
    } else {
      throw Exception('Failed to load chats');
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<List<dynamic>> chatsLocalSearch(String chatId, String query) async {
  final String? token = await getToken(); // Retrieve token from secure storage
  final Uri url =
      Uri.parse('http://$ip:5000/api/chats/$chatId/searchMembers?query=$query');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['users'];
    } else {
      throw Exception('Failed to load users');
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}
