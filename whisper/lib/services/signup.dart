import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/modules/signup-credentials.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/pages/recaptcha.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> signup(BuildContext context) async {
  SignupCredentials user = await GetSignUpCredentials();
  String? robotToken = await GetRobotToken();
  final url = Uri.parse('http://$ip:5000/api/auth/signup');
  final userMap = user.toMap();
  userMap.addAll({"robotToken": robotToken});
  // print(userMap);
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userMap),
    );

    var data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await SaveEmail(user.email!);
      Navigator.pushReplacementNamed(context, ConfirmationCode.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: ${data['message']}"),
        ),
      );
    }
  } catch (e) {
    print("error:$e");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text("Something went wrong: ${e}"),
    //   ),
    // );
  }
}
