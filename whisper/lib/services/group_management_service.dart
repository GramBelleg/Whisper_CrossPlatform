import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupManagementService {
  String? _token;

  Future<Map<String, dynamic>> getGroupSettings(int chatId) async {
    // this is equivalent to if (_token == null) _token = await getToken();
    _token ??= await getToken();

    if (_token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      final Uri url = Uri.parse('http://$ip:5000/api/groups/$chatId/settings');

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
        throw Exception('Failed to Load group settings');
      }
    } catch (e) {
      throw Exception('Failed to load group settings: $e');
    }
  }

  Future<void> setGroupPrivacy(int chatId, bool isPrivate) async {
    // this is equivalent to if (_token == null) _token = await getToken();
    _token ??= await getToken();

    if (_token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      final Uri url = Uri.parse('http://$ip:5000/api/groups/$chatId/privacy');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'isPrivate': isPrivate}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print('Updated group privacy to $isPrivate');
      } else {
        throw Exception('Failed to update group privacy to $isPrivate');
      }
    } catch (e) {
      throw Exception('Failed to update group privacy: $e');
    }
  }

  Future<void> setGroupMaxSize(int chatId, int maxSize) async {
    // this is equivalent to if (_token == null) _token = await getToken();
    _token ??= await getToken();

    if (_token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      final Uri url =
          Uri.parse('http://$ip:5000/api/groups/$chatId/size/$maxSize');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print('Updated group max size to $maxSize');
      } else {
        throw Exception('Failed to update group max size to $maxSize');
      }
    } catch (e) {
      throw Exception('Failed to update group max size: $e');
    }
  }

  Future<Map<String, bool>> getUserPermissions(int chatId, int userId) async {
    // this is equivalent to if (_token == null) _token = await getToken();
    _token ??= await getToken();

    if (_token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      final Uri url =
          Uri.parse("http://$ip:5000/api/groups/$chatId/$userId/permissions");

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
        throw Exception('Failed to Load user permissions');
      }
    } catch (e) {
      throw Exception('Failed to load user permissions: $e');
    }
  }

  Future<void> setUserPermissions(
      int chatId, int userId, Map<String, bool> settings) async {
    // this is equivalent to if (_token == null) _token = await getToken();
    _token ??= await getToken();

    if (_token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      final Uri url =
          Uri.parse('http://$ip:5000/api/groups/$chatId/$userId/permissions');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(settings),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print('Updated group settings to $settings');
      } else {
        throw Exception('Failed to update group settings to $settings');
      }
    } catch (e) {
      throw Exception('Failed to update group settings: $e');
    }
  }
}
