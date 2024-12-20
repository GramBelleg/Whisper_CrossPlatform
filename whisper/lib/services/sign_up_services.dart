import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/components/page_state.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/models/sign_up_credentials.dart';
import 'package:whisper/pages/confirmation_code.dart';
import 'package:whisper/services/login_service.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';

class SignupService {
  static Future<void> signup(
      BuildContext context, SignupCredentials? user) async {
    String? robotToken = await getRobotToken();
    final url = Uri.parse('http://$ip:5000/api/auth/signup');
    final userMap = user!.toMap();
    print("number is :${userMap['phoneNumber']}");
    userMap.addAll({"robotToken": robotToken});
    // print(userMap);
    showLoadingDialog(context);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userMap),
      );
      Navigator.pop(context);

      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await saveEmail(user.email!);
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
      showLoadingDialog(context);

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
      Navigator.pop(context);

      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Response: $data');
        await saveEmail(email);
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
          content: Text("Something went wrong : $e"),
        ),
      );
    }
  }

  static Future<void> confirmCode(String code, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/auth/confirmEmail');
    final email = await getEmail();
    showLoadingDialog(context);
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
      Navigator.pop(context);

      var data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Response: $data');
        await saveToken(data['userToken']);
        await saveId(data['user']['id']);
        try {
          String? firebaseToken = await FirebaseMessaging.instance.getToken();
          await LoginService.registerFCMToken(
              firebaseToken, data['userToken'], context);
        } catch (e) {
          print(e);
        }
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
          content: Text("Something went wrong: $e"),
        ),
      );
    }
  }
}
