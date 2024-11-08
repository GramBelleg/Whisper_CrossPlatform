// services/chat_deletion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';
import '../constants/ip-for-services.dart';

class ChatDeletionService {
  Future<void> deleteMessages(int chatId, List<int> messageIds) async {
    final url = Uri.parse(
        'http://$ip:5000/api/chats/$chatId/deleteForMe'); // Use chatId in the URL

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

    if (response.statusCode != 200) {
      throw Exception('Failed to delete messages: ${response.statusCode}');
    }
  }
}
