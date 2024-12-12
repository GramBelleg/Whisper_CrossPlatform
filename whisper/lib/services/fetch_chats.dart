import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';

Future<List<dynamic>> fetchChats() async {
  final String url = 'http://$ip:5000/api/chats';
  String? token = await getToken(); // Retrieve token

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> chats = jsonDecode(response.body);
      print("chats  $chats");
      return chats;
    } else {
      throw Exception('Failed to load chats');
    }
  } catch (e) {
    print('Error fetching chats: $e');
    return [];
  }
}
