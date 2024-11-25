import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/models/chat-messages.dart'; // Assuming this is where ChatMessage model is
import 'package:whisper/services/shared-preferences.dart';

class ChatViewModel {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  Future<void> fetchChatMessages(int chatId) async {
    final url = Uri.parse('http://192.168.1.11:5000/api/messages/$chatId');
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

      // Now we extract the messages array from the response
      List<dynamic> messagesData = jsonData['messages'];
      print("3333333333333333333333");
      print(messagesData);
      // Convert the messages into a list of ChatMessage objects
      _messages =
          messagesData.map((message) => ChatMessage.fromJson(message)).toList();
      print("hiiiiiiiiiiiiiiiii${messagesData.length}");
      // You can uncomment the next line if using state management (like ChangeNotifier)
      //  notifyListeners(); // Notify listeners when data changes
    } else {
      throw Exception('Failed to load chat messages: ${response.statusCode}');
    }
  }
}
