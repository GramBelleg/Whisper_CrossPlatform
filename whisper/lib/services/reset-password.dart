import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/modules/reset-password-credentials.dart';
import 'package:whisper/modules/signup-credentials.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> resetPassword(
    ResetPasswordCredentials resetPassCred, BuildContext context) async {
  final url = Uri.parse('http://10.0.2.2:5000/api/auth/resetPassword');
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
        content: Text("Something went wrong: ${e}"),
      ),
    );
  }
}
