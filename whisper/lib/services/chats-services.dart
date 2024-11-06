import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

Future<List<dynamic>> fetchChats() async {
  final String url = 'http://192.168.1.11:5000/api/chats';
  String? token = await GetToken(); // Retrieve token
  print("Hello, Flutter!");
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
      print(chats);
      return chats;
    } else {
      throw Exception('Failed to load chats');
    }
  } catch (e) {
    print('Error fetching chats: $e');
    return [];
  }
}
