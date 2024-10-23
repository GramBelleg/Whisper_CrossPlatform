import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

// ChatMessage model
class ChatMessage {
  final int id;
  final int chatId;
  final int senderId;
  final String content;
  final DateTime createdAt;
  final bool forwarded;
  final bool pinned;
  final bool selfDestruct;
  final int? expiresAfter;
  final String type;
  final int? parentMessageId;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.forwarded,
    required this.pinned,
    required this.selfDestruct,
    this.expiresAfter,
    required this.type,
    this.parentMessageId,
  });

  // Factory constructor to create a ChatMessage object from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      forwarded: json['forwarded'],
      pinned: json['pinned'],
      selfDestruct: json['selfDestruct'],
      expiresAfter: json['expiresAfter'],
      type: json['type'],
      parentMessageId: json['parentMessageId'],
    );
  }
}

// Fetch chat messages function with Bearer token
Future<List<ChatMessage>> fetchChatMessages() async {
  final url = Uri.parse('http://192.168.1.11:5000/api/chats/4');
  String? token = await GetToken();
  print(token);
  // Add the Authorization header with Bearer token
  final response = await http.get(
    url,
    headers: {
      'Authorization':
          'Bearer ${token}', // Include the Bearer token in the request
      'Content-Type': 'application/json', // Set the content type
    },
  );

  print("Response status code: ${response.statusCode}");

  if (response.statusCode == 200) {
    // Decode the response body into a List of ChatMessages
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((message) => ChatMessage.fromJson(message)).toList();
  } else {
    throw Exception('Failed to load chat messages');
  }
}
