import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

// ParentMessage model
class ParentMessage {
  final String content;
  final String media;

  ParentMessage({
    required this.content,
    required this.media,
  });

  // Factory constructor to create a ParentMessage object from JSON
  factory ParentMessage.fromJson(Map<String, dynamic> json) {
    return ParentMessage(
      content: json['content'],
      media: json['media'],
    );
  }

  // Method to convert a ParentMessage object to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'media': media,
    };
  }
}

class ChatMessage {
  final int? id;
  final int chatId;
  final int? senderId;
  final String content;

  final bool? forwarded;
  final bool? pinned;
  final bool? selfDestruct;
  final int? expiresAfter;
  final String type;
  DateTime? time;
  DateTime? sentAt;
  final int? parentMessageId;
  final ParentMessage? parentMessage;

  ChatMessage({
    this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.forwarded,
    this.pinned,
    this.selfDestruct,
    this.expiresAfter,
    required this.type,
    this.time,
    required this.sentAt,
    this.parentMessageId,
    this.parentMessage,
  });

  // Factory constructor to create a ChatMessage object from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      sentAt: DateTime.parse(json['sentAt']),
      forwarded: json['forwarded'],
      pinned: json['pinned'],
      selfDestruct: json['selfDestruct'],
      expiresAfter: json['expiresAfter'],
      type: json['type'],
      time: DateTime.parse(json['time']),
      parentMessageId: json['parentMessageId'],
      parentMessage: json['parentMessage'] != null
          ? ParentMessage.fromJson(json['parentMessage'])
          : null,
    );
  }

  // Method to convert a ChatMessage object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt?.toIso8601String(),
      'forwarded': forwarded,
      'pinned': pinned,
      'selfDestruct': selfDestruct,
      'expiresAfter': expiresAfter,
      'type': type,
      'time': time?.toIso8601String(),
      'parentMessageId': parentMessageId,
      'parentMessage': parentMessage?.toJson(),
    };
  }
}

// Fetch chat messages function with Bearer token
Future<List<ChatMessage>> fetchChatMessages(int chatId) async {
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
  print("555555555555555");
  print("Response status code: ${response.statusCode}");

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData
        .cast<Map<String, dynamic>>()
        .map((message) => ChatMessage.fromJson(message))
        .toList();
  } else {
    throw Exception('Failed to load chat messages: ${response.statusCode}');
  }
}
