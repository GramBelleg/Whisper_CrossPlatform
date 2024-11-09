import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

Future<Map<String, dynamic>> verifyEmailCode(
    String code, String email, BuildContext context) async {
  final url = Uri.parse('http://172.20.192.1:5000/api/user/email');
  String? token = await GetToken();
  print(code + "      " + email);
  print("in verifyEmailCode");
  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
      return {
        'success': true,
        'message': data['data'],
      };
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: ${data['message']}"),
        ),
      );
      print('Response: $data');
      return {
        'success': false,
        'message': data['message'],
      };
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Something went wrong: ${e}"),
      ),
    );
    return {
      'success': false,
      'message': "Verify Field",
    };
  }
}
