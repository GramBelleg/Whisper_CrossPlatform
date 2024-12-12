import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/components/page_state.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/models/login_credentials.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';

class LoginService {
  static Future<void> registerFCMToken(String? fcmToken,String token, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/notifications/registerFCMToken');
    print("BEFORE");
    showLoadingDialog(context);
    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"fcmToken":fcmToken}),
      );
      var data = jsonDecode(response.body);
      print("INSIDE FCM TOKEN");
      print(data);
      Navigator.pop(context);
    }

    catch (e){
      print(e);
    }
  }

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
        print("Before");
        String? firebaseToken = await FirebaseMessaging.instance.getToken();
        print("FIRE BASE TOKEN : $firebaseToken");
        await registerFCMToken(firebaseToken,data['userToken'], context);
        await saveToken(data['userToken']);
        await saveId(data['user']['id']);
        print('Response: $data');
        await saveEmail(loginCred.email!);
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
    } catch (e) {
      print(e);
    }
  }

  static Future<bool?> checkAlreadyLoggedIn(BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/user');
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}
