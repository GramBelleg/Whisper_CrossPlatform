import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/components/page_state.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/models/login_credentials.dart';
import 'package:whisper/pages/admin_dashboard.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';

class LoginService {
  static Future<void> registerFCMToken(
      String? fcmToken, String token, BuildContext context) async {
    final url = Uri.parse('$ip/notifications/registerFCMToken');
    print("BEFORE");
    showLoadingDialog(context);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"fcmToken": fcmToken}),
      );
      var data = jsonDecode(response.body);
      print("INSIDE FCM TOKEN");
      print(data);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> login(
      LoginCredentials loginCred, BuildContext context) async {
    final url = Uri.parse('$ip/auth/login');
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
        print("Before");
        try {
          String? firebaseToken = await FirebaseMessaging.instance.getToken();
          print("FIRE BASE TOKEN : $firebaseToken");
          await registerFCMToken(firebaseToken, data['userToken'], context);
        } catch (e) {
          print("ERROR FIRE BASE");
          print(e);
        }

        await saveToken(data['userToken']);
        await saveId(data['user']['id']);
        print('Response: $data');
        await saveEmail(loginCred.email!);
        await saveRole(data['user']['role']);
        if (data['user']['role'] != 'Admin') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageState.id,
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AdminDashboard.id,
            (Route<dynamic> route) => false,
          );
        }
      } else {
        print("ERRRRRRRRROR");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: ${data['message']}"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> checkAlreadyLoggedIn(BuildContext context) async {
    final url = Uri.parse('$ip/user');
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
      String? role = await getRole();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return role;
      } else {
        return '';
      }
    } catch (e) {
      print(e);
    }
  }
}
