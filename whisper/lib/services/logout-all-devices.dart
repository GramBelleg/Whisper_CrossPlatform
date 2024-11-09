import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> logoutFromAllDevices(BuildContext context) async {
  final url = Uri.parse('http://172.20.192.1:5000/api/user/logoutAll');
  final token = await GetToken();
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = jsonDecode(response.body);
      print('Response: $data');
      Navigator.pushNamed(context, Login.id);
    } else {
      print(response);
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
