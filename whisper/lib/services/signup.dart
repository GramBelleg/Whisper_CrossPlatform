import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/modules/signup-credentials.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> signup(SignupCredentials user, BuildContext context) async {
  final url = Uri.parse('http://192.168.1.11:5000/api/auth/signup');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = jsonDecode(response.body);
      print('Response: $data');
      await SaveEmail(user.email!);
      Navigator.pushNamed(context, ConfirmationCode.id);
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
