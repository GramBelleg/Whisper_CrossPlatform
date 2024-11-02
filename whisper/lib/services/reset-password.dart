import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/modules/reset-password-credentials.dart';
import 'package:whisper/pages/logout-after-reset-password.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> resetPassword(
    ResetPasswordCredentials resetPassCred, BuildContext context) async {
  final url = Uri.parse('http://192.168.1.11:5000/api/auth/resetPassword');
  resetPassCred.email = await GetEmail();
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(resetPassCred.toMap()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = jsonDecode(response.body);
      print('Response: $data');
      await SaveToken(data['userToken']);
      Navigator.pushNamed(context, LogoutAfterResetPassword.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: ${response.statusCode}"),
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
