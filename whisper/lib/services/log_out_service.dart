import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';
import 'package:whisper/socket.dart';

class LogoutService {
  static Future<void> logoutFromAllDevices(BuildContext context) async {
    final url = Uri.parse('$ip/user/logoutAll');
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

      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        SocketService.instance.dispose();
        print('Response: $data');
        Navigator.pushNamedAndRemoveUntil(
          context,
          Login.id,
          (Route<dynamic> route) => false,
        );
      } else {
        print(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: ${data['message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
        ),
      );
    }
  }

  static Future<void> logoutFromThisDevice(BuildContext context) async {
    final url = Uri.parse('$ip/user/logoutOne');
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

      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        SocketService.instance.dispose();
        print('Response: $data');
        Navigator.pushNamedAndRemoveUntil(
          context,
          Login.id,
          (Route<dynamic> route) => false,
        );
      } else {
        print(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: ${data['message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
        ),
      );
    }
  }
}
