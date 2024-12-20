import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/pages/reset_password.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';

import '../models/reset_password_credentials.dart';
import '../pages/log_out_after_reset_password.dart';
import 'login_service.dart';

class ResetPasswordService {
  static Future<void> sendResetCode(String email, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/auth/sendResetCode');
    showLoadingDialog(context);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "email": email,
          },
        ),
      );
      Navigator.pop(context);

      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Response: $data');
        await saveEmail(email);
        if (ModalRoute.of(context)?.settings.name != ResetPassword.id) {
          Navigator.pushNamed(context, ResetPassword.id);
        }
      } else {
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

  static Future<void> resetPassword(
      ResetPasswordCredentials resetPassCred, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/auth/resetPassword');
    resetPassCred.email = await getEmail();
    try {
      showLoadingDialog(context);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(resetPassCred.toMap()),
      );
      Navigator.pop(context);

      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Response: $data');
        await saveToken(data['userToken']);
        await saveId(data['user']['id']);
        try {
          String? firebaseToken = await FirebaseMessaging.instance.getToken();
          await LoginService.registerFCMToken(
              firebaseToken, data['userToken'], context);
        } catch (e) {
          print(e);
        }
        Navigator.pushNamed(context, LogoutAfterResetPassword.id);
      } else {
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
