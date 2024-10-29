import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/pages/chat-page.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> confirmCode(String code, BuildContext context) async {
  final url = Uri.parse('http://$ip:5000/api/auth/confirmEmail');
  final email = await GetEmail();
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'code': code,
        },
      ),
    );
    var data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Response: $data');
      await SaveToken(data['userToken']);
      Navigator.pushNamedAndRemoveUntil(
        context,
        ChatPage.id,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Something went wrong: ${e}"),
      ),
    );
  }
}
