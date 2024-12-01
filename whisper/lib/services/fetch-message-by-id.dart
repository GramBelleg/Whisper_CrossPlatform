// services/fetch_message.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/models/chat-messages.dart'; // Ensure this import points to your ChatMessage model
import 'package:whisper/services/shared-preferences.dart';

Future<ChatMessage> fetchMessage(int messageId) async {
  final url =
      Uri.parse('http://192.168.2.100:5000/api/messages/$messageId/getMessage');
  String? token = await GetToken();

  if (token == null) {
    throw Exception('Authorization token is missing');
  }

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);
    ChatMessage message = ChatMessage.fromJson(jsonData);
    return message;
  } else {
    throw Exception('Failed to load message: ${response.statusCode}');
  }
}
