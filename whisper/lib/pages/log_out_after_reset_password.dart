import 'package:flutter/material.dart';
import 'package:whisper/components/custom_highlight_text.dart';
import 'package:whisper/components/page_state.dart';
import 'package:whisper/services/log_out_service.dart';
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
          key: formKey,
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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        PageState.id,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  CustomHighlightText(
                    callToActionText: "Yes",
                    onTap: () async {
                      await LogoutService.logoutFromAllDevices(context);
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
