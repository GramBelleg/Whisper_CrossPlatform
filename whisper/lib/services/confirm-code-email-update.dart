import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

import '../constants/ip-for-services.dart';

Future<Map<String, dynamic>> sendConfirmationCodeEmail(
    String email, BuildContext context) async {
  final url = Uri.parse('http://$ip:5000/api/user/emailcode');
  String? token = await GetToken();
  print('Responseddddddddddddddddddddddddddddddddddddddd:');
  // Ensure token is not null before making the request
  if (token == null) {
    print('Token is null, cannot verify email code.');
    return {
      'success': false,
      'message': 'Token is null, cannot verify email code.'
    };
  }
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "email": email,
      }),
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Parse response body
      print('Response: $responseData');

      return {
        'success': true,
      };
    } else {
      print('Responseddddddddddddddddddddddddddddddddddddddd: $responseData');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Something went wrong : ${responseData['message']}"),
      //   ),
      // );

      return {
        'success': false,
        'message': responseData['message'],
      };
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Something went wrong : ${e}"),
      ),
    );
    return {
      'success': false,
      'message': 'send code failed',
    };
  }
}
