import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/components/custom-access-button.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/constants/colors.dart';
import 'dart:convert';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/services/shared-preferences.dart';

import 'login.dart';

class LoginWithGoogle extends StatelessWidget {
  static const String id = "/LoginWithGoogle";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
            ),
            CustomAccessButton(
              label: "Sign in with google",
              onPressed: () async {
                await signOutGoogle(); // Sign out any existing user before sign in
                GoogleSignInAccount? account = await getGoogleAuthCode();
                print("AUTHCODE: $account");
                if (account != null) {
                  print('Auth Code: ${account.serverAuthCode}');
                  await sendAuthCodeToBackend(account.serverAuthCode!, context);
                }
              },
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: CustomHighlightText(
                callToActionText: "Go back",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signOutGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId:
          '17818726142-7fd5nu3iima7cf78kb1abf3shfuo4vqh.apps.googleusercontent.com',
    );

    try {
      await _googleSignIn.signOut();
      print("User signed out.");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  Future<GoogleSignInAccount?> getGoogleAuthCode() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId:
          '17818726142-7fd5nu3iima7cf78kb1abf3shfuo4vqh.apps.googleusercontent.com',
    );

    try {
      // Start the sign-in process
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        return account; // Fetching the server auth code
      } else {
        print("Failed to get account.");
        return null;
      }
    } catch (error) {
      print("Error signing in: $error");
      return null;
    }
  }

  Future<void> sendAuthCodeToBackend(
      String authCode, BuildContext context) async {
    final url =
        'http://192.168.1.8:5000/api/auth/google'; // Your backend endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': authCode}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('User data: $data');
        await SaveToken(data['userToken']);
        Navigator.pushNamed(context, Login.id);
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }
}
