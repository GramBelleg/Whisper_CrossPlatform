import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/url.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';
import '../../constants/ip_for_services.dart';

Future<List<dynamic>> fetchChats() async {
  final String url = '$domain_name/chats';
  String? token = await getToken(); // Retrieve token
  print("url $url");
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> chats = jsonDecode(response.body);

      for (var chat in chats) {
        chat['picture'] = chat['picture'] != null
            ? await generatePresignedUrl(chat['picture'])
            : 'https://ui-avatars.com/api/?background=8d6aee&size=100&color=fff&name=${formatName(chat['name'])}';
        print("chat aaa$chat");
      }
      print("chats here $chats");
      return chats;
    } else {
      throw Exception('Failed to load chats');
    }
  } catch (e) {
    print('Error fetching chats: $e');
    return [];
  }
}
