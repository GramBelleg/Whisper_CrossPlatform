import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> logoutFromAllDevices(BuildContext context) async {
  final url = Uri.parse('http://$ip:5000/api/user/logoutAll');
  final token = await GetToken();
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Response: $data');
      Navigator.pushNamedAndRemoveUntil(
        context,
        Login.id,
        (Route<dynamic> route) => false,
      );
    } else {
      print(response);
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
