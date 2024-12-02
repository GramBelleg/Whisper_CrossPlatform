import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/models/chat_message.dart';
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';

class ChatViewModel {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  Future<void> fetchChatMessages(int chatId) async {
    final url = Uri.parse('http://$ip:5000/api/messages/$chatId');
    String? token = await getToken();

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

      List<dynamic> messagesData = jsonData['messages'];
      print(messagesData);

      _messages =
          messagesData.map((message) => ChatMessage.fromJson(message)).toList();
    } else {
      throw Exception('Failed to load chat messages: ${response.statusCode}');
    }
  }
}
