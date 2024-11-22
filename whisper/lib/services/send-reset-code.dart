import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/pages/reset-password.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> sendResetCode(String email, BuildContext context) async {
  final url = Uri.parse('http://localhost:5000/api/auth/sendResetCode');
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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = jsonDecode(response.body);
      print('Response: $data');
      await SaveEmail(email);
      Navigator.pushNamed(context, ResetPassword.id);
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
