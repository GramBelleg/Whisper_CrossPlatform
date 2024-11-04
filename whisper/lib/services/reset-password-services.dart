import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/pages/reset-password.dart';
import 'package:whisper/services/shared-preferences.dart';

import '../modules/reset-password-credentials.dart';
import '../pages/logout-after-reset-password.dart';
class ResetPasswordService{
  static Future<void> sendResetCode(String email, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/auth/sendResetCode');
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
      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Response: $data');
        await SaveEmail(email);
        Navigator.pushNamed(context, ResetPassword.id);
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
          content: Text("Something went wrong: ${e}"),
        ),
      );
    }
  }
  static Future<void> resetPassword(
      ResetPasswordCredentials resetPassCred, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/auth/resetPassword');
    resetPassCred.email = await GetEmail();
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(resetPassCred.toMap()),
      );
      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Response: $data');
        await SaveToken(data['userToken']);
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
          content: Text("Something went wrong: ${e}"),
        ),
      );
    }
  }
}
