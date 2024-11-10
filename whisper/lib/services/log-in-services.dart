import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/components/page-state.dart';
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/modules/login-credentials.dart';
import 'package:whisper/pages/chat-page.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/show-loading-dialog.dart';

class LoginService {
  static Future<void> login(
      LoginCredentials loginCred, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/auth/login');
    showLoadingDialog(context);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginCred.toMap()),
      );
      Navigator.pop(context);
      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await SaveToken(data['userToken']);
        print('Response: $data');
        await SaveEmail(loginCred.email!);
        Navigator.pushNamedAndRemoveUntil(
          context,
          PageState.id,
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: ${data['message']}"),
          ),
        );
      }
    } catch (e) {}
  }

  static Future<bool?> CheckAlreadyLoggedIn(BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/user');
    final token = await GetToken();
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
        return true;
      } else {
        return false;
      }
    } catch (e) {}
  }
}
