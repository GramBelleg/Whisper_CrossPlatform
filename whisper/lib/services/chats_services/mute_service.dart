import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/constants/url.dart';
import 'package:whisper/services/shared_preferences.dart';

Future<bool> muteChatService(int chatId, int duration) async {
  final apiUrl = '$domain_name/chats/$chatId/muteChat';
  String? token = await getToken();
  print("mute");
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "duration": duration,
      }),
    );
    print("mute:${response.body}");
    if (response.statusCode == 200) {
      print('Chat muted successfully.');
      return true;
    } else {
      final errorResponse = json.decode(response.body);
      print('Failed to mute chat: ${errorResponse['message']}');
      return false;
    }
  } catch (error) {
    print('Error mute: $error');
    return false;
  }
}
