import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/logout-all-devices.dart';
import '../constants/colors.dart';

class LogoutAfterResetPassword extends StatelessWidget {
  LogoutAfterResetPassword({super.key});

  static String id = "/LogoutAfterResetPassword";
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
        child: Form(
          key: this.formKey,
          child: ListView(
            children: [
              Image.asset(
                'assets/images/whisper-logo.png',
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  "Would you like to logout from all previously logged in devices?",
                  style: TextStyle(
                    fontSize: 20,
                    color: secondNeutralColor,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomHighlightText(
                    callToActionText: "No",
                    onTap: () async {
                      Navigator.pushNamed(context, Login.id);
                    },
                  ),
                  CustomHighlightText(
                    callToActionText: "Yes",
                    onTap: () async {
                      await logoutFromAllDevices(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
