// viewmodels/chat_viewmodel.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/models/chat-messages';

import 'package:whisper/services/shared-preferences.dart';

class ChatViewModel extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;
  void refreshMessages() {
    notifyListeners(); // This will trigger a rebuild of any listeners, including your chat page
  }

  Future<void> fetchChatMessages(int chatId) async {
    final url = Uri.parse('http://localhost:5000/api/chats/$chatId');
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
      List<dynamic> jsonData = json.decode(response.body);
      _messages = jsonData
          .cast<Map<String, dynamic>>()
          .map((message) => ChatMessage.fromJson(message))
          .toList();
      notifyListeners(); // Notify listeners when data changes
    } else {
      throw Exception('Failed to load chat messages: ${response.statusCode}');
    }
  }

  Future<void> deleteMessages(int chatId, List<int> messageIds) async {
    final url = Uri.parse(
        'http://localhost:5000/api/chats/$chatId/deleteForMe'); // Use chatId in the URL
    String? token = await GetToken();

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'Ids': messageIds, // Send the list of message IDs
        'chatId': chatId, // Include the chatId in the request body
      }),
    );

    if (response.statusCode == 200) {
      // Remove the messages from _messages
      _messages.removeWhere((message) => messageIds
          .contains(message.id)); // Assuming ChatMessage has an 'id' property
      notifyListeners(); // Notify listeners about the updated message list
      messages.removeWhere((message) => messages.contains(message.id));
    } else {
      throw Exception('Failed to delete messages: ${response.statusCode}');
    }
  }
}
