import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/components/page-state.dart';
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/modules/signup-credentials.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/services/shared-preferences.dart';

class SignupService {
  static Future<void> signup(
      BuildContext context, SignupCredentials? user) async {
    String? robotToken = await GetRobotToken();
    final url = Uri.parse('http://$ip:5000/api/auth/signup');
    final userMap = user!.toMap();
    print("number is :${userMap['phoneNumber']}");
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

  static Future<void> sendConfirmationCode(
      String email, BuildContext context) async {
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
            content: Text("Something went wrong : ${data['message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong : ${e}"),
        ),
      );
    }
  }

  static Future<void> confirmCode(String code, BuildContext context) async {
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
          PageState.id,
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
}
