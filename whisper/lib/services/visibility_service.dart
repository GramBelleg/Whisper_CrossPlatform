import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:whisper/constants/url.dart';
import '../constants/ip_for_services.dart';
import 'shared_preferences.dart';
import 'package:http/http.dart' as http;

class VisibilityService {
  String? _token;

  Future<Map<String, dynamic>> getVisibilitySettings() async {
    _token = await getToken();

    try {
      final Uri url = Uri.parse("$domain_name/user/info");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to Load visibility settings");
      }
    } catch (e) {
      throw Exception("Failed to load visibility settings: $e");
    }
  }

  Future<void> updateVisibilitySetting(String key, dynamic value) async {
    if (key == "readReceipts") {
      // it is a post request here

      final Uri url = Uri.parse("$domain_name/user/readReceipts");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {"readReceipts": value},
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print("Updated readreceipts to $value");
      } else {
        throw Exception("Failed to update readReceipts to $value");
      }
    } else {
      // it is a put request here
      final Uri url = Uri.parse("$domain_name/user/$key/privacy");

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {"privacy": value},
        ),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) print("Updated $key to $value");
      } else {
        throw Exception('Failed to update visibility setting of key $key');
      }
    }
  }
}
