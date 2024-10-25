import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/modules/login-credentials.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<bool?> CheckAlreadyLoggedIn(BuildContext context) async {
  final url = Uri.parse('http://10.0.2.2:5000/api/user');
  final token = await GetToken();
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Something went wrong: ${e}"),
      ),
    );
  }
}
