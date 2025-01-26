import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupManagementService {
  String? _token;

  Future<void> _ensureToken() async {
    _token ??= await getToken();
    if (_token == null) {
      throw Exception('Authorization token is missing');
    }
  }

  Future<Map<String, dynamic>> getGroupSettings(int chatId) async {
    await _ensureToken();
    try {
      final Uri url = Uri.parse('$ip/groups/$chatId/settings');
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
        throw Exception(
            'Failed to load group settings. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load group settings: $e');
    }
  }

  Future<bool> setGroupPrivacy(int chatId, bool isPrivate) async {
    await _ensureToken();
    try {
      final Uri url = Uri.parse('$ip/chats/$chatId/privacy');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'isPrivate': isPrivate}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update group privacy. Status code: ${response.statusCode}');
      }

      if (kDebugMode) print('Updated group privacy to $isPrivate');
      return true;
    } catch (e) {
      throw Exception('Failed to update group privacy: $e');
    }
  }

  Future<bool> setGroupMaxSize(int chatId, int maxSize) async {
    await _ensureToken();
    try {
      final Uri url = Uri.parse('$ip/groups/$chatId/size/$maxSize');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update group max size. Status code: ${response.statusCode}');
      }

      if (kDebugMode) print('Updated group max size to $maxSize');
      return true;
    } catch (e) {
      throw Exception('Failed to update group max size: $e');
    }
  }

  Future<Map<String, bool>> getUserPermissions(int chatId, int userId) async {
    await _ensureToken();
    try {
      final Uri url = Uri.parse('$ip/groups/$chatId/$userId/permissions');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Map<String, bool>.from(data);
      } else {
        throw Exception(
            'Failed to load user permissions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user permissions: $e');
    }
  }

  Future<bool> setUserPermissions(
      int chatId, int userId, Map<String, bool> permissions) async {
    await _ensureToken();
    try {
      final Uri url = Uri.parse('$ip/groups/$chatId/$userId/permissions');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(permissions),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update user permissions. Status code: ${response.statusCode}');
      }

      if (kDebugMode) print('Updated user permissions to $permissions');
      return true;
    } catch (e) {
      throw Exception('Failed to update user permissions: $e');
    }
  }
}
