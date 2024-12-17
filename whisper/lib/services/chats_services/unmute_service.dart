import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/services/shared_preferences.dart';

Future<bool> unmuteChatService(int chatId) async {
  String url = 'http://$ip:5000/api/chats/$chatId/unmuteChat';
  String? token = await getToken();

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("unmute api:${response.body}");

    if (response.statusCode == 200) {
      print('Chat unmuted successfully.');
      return true;
    } else {
      print('Failed to unmute chat.');
      return false;
    }
  } catch (error) {
    print('Error unmute: $error');
    return false;
  }
}
