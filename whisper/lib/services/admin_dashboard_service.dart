import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/constants/url.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';

class AdminDashboardService {
  static Future<List<dynamic?>?> getAllUsers(BuildContext context) async {
    final url = Uri.parse('$domain_name/admin/users');
    final token = await getToken();
    showLoadingDialog(context);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      Navigator.pop(context);
      print("Response:$response");
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        return data;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<List<dynamic?>?> getAllGroups(BuildContext context) async {
    final url = Uri.parse('$domain_name/admin/groups');
    final token = await getToken();
    showLoadingDialog(context);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      Navigator.pop(context);
      print("Response:$response");
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        return data;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> banAUser(
      BuildContext context, bool ban, int userId) async {
    final url = Uri.parse('$domain_name/admin/ban/$ban/user/$userId');
    final token = await getToken();
    showLoadingDialog(context);

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      Navigator.pop(context);
      print("Response:$response");
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> filterGroup(
      BuildContext context, bool filter, int userId) async {
    final url =
        Uri.parse('$domain_name/admin/filter/$filter/group/$userId');
    final token = await getToken();
    showLoadingDialog(context);

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      Navigator.pop(context);
      print("Response:$response");
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
