import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginWithFacebook extends StatefulWidget {
  static const String id = '/LoginWithFacebook';

  @override
  _LoginWithFacebookState createState() => _LoginWithFacebookState();
}

class _LoginWithFacebookState extends State<LoginWithFacebook> {
  String? errorMessage;

  Future<void> loginWithFacebook() async {
    // Trigger the Facebook Login
    print("ABL");
    final LoginResult result = await FacebookAuth.instance.login();
    print("B3d");
    if (result.status == LoginStatus.success) {
      // Get the access token
      final String? accessToken =
          result.accessToken?.tokenString; // Use .value instead of .token

      // Now send this token to your backend to get user data
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/facebook'),
        // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'code': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle successful login, store user data and token as needed
        print('User Data: ${data['user']}');
        // Optionally navigate to another page
      } else {
        setState(() {
          errorMessage = 'Login failed: ${response.body}';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Facebook login failed: ${result.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facebook Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: loginWithFacebook,
              child: Text('Login with Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
