import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';

Future<List<dynamic>> chatsGlobalSearch(String query) async {
  final String? token = await getToken(); // Retrieve token from secure storage
  final Uri url =
      Uri.parse('http://$ip:5000/api/chats/globalSearch?query=$query');

  try {
    // Simulate a delay of 2 seconds (you can adjust the time as needed)
    await Future.delayed(Duration(seconds: 2));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> filteredChats = [];

      for (var chat in data['chats']) {
        if (chat['type'] == 'DM') {
          String? mediaUrl;

          if (chat['picture'] != null) {
            mediaUrl = await generatePresignedUrl(chat['picture']);
          } else {
            mediaUrl =
                'https://ui-avatars.com/api/?background=8d6aee&size=1500&color=fff&name=${formatName(chat['name'])}';
          }

          chat['profilePicUrl'] = mediaUrl == ''
              ? 'https://ui-avatars.com/api/?background=8d6aee&size=1500&color=fff&name=${formatName(chat['name'])}'
              : mediaUrl;

          filteredChats.add(chat);
        }
      }

      return filteredChats;
    } else {
      throw Exception('Failed to load chats');
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}
