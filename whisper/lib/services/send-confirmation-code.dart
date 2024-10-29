import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/pages/reset-password.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> sendConfirmationCode(String email, BuildContext context) async {
  final url = Uri.parse('http://$ip:5000/api/auth/resendConfirmCode');
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
