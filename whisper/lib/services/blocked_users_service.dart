import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';
import '../constants/ip-for-services.dart';

class BlockedUsersService {
  final String baseURL = "http://$ip:5000/api/user/blocked";
  String? _token;

  Future<List<Map<String, dynamic>>> fetchBlockedUsers() async {
    _token = await GetToken();

    final response = await http.get(
      Uri.parse(baseURL),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map<Map<String, dynamic>>((user) => {
                'userId': user['userId'],
                'userName': user['userName'],
                'profilePic': user['profilePic'],
              })
          .toList();
    } else {
      throw Exception("Failed to load blocked users");
    }
  }

  Future<void> changeBlock(int userId, bool value) async {
    final url = Uri.parse("http://$ip:5000/api/user/block");
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          "users": [userId],
          "blocked": value
        },
      ),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) print("$userId : blocked = $value");
    } else {
      throw Exception("Failed to change block state of $userId to $value");
    }
  }
}
