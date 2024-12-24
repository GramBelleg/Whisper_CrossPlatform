import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/url.dart';
import 'package:whisper/models/chat_message.dart';
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ChatViewModel {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  Future<void> fetchChatMessages(int chatId) async {
    final url = Uri.parse('$domain_name/messages/$chatId');
    String? token = await getToken();
    if (token == null) {
      print('Authorization token is missing');
      return;
    }

    try {
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

        _messages = messagesData
            .map((message) => ChatMessage.fromJson(message))
            .toList();
        await cacheMessages(chatId, _messages);
      } else {
        print('Failed to load chat messages: ${response.statusCode}');
      }
    } catch (e) {
      _messages = await loadCachedMessages(chatId);
      print('Error while fetching chat messages: $e');
    }
  }
}
