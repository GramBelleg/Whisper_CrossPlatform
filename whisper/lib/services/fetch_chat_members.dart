// services/fetch_members.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/models/group_member.dart';
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';

Future<List<GroupMember>> fetchChatMembers(int chatId) async {
  final url = Uri.parse('http://$ip:5000/api/chats/$chatId/getMembers');
  String? token = await getToken();

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
    print("aaaaaaaaaaaaaaa");
    List<dynamic> jsonData = json.decode(response.body);
    List<GroupMember> members =
        jsonData.map((data) => GroupMember.fromJson(data)).toList();
    for (var member in members) {
      print(member);
    }
    return members;
  } else {
    throw Exception('Failed to load chat members: ${response.statusCode}');
  }
}
