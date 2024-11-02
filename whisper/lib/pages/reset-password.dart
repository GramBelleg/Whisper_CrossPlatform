import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/modules/reset-password-credentials.dart';
import 'package:whisper/services/send-reset-code.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/validators/form-validation/password-field-validation.dart';
import 'package:whisper/validators/reset-password-validation/confirmation-code-validation.dart';
import '../components/custom-access-button.dart';
import '../components/custom-text-field.dart';
import '../constants/colors.dart';
import '../services/reset-password.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  static String id = "/ResetPassword";
  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm(context) async {
    if (formKey.currentState!.validate()) {
      ResetPasswordCredentials resetPasswordCredentials =
          ResetPasswordCredentials(
        password: _passwordController.text,
        confirmPassword: _rePasswordController.text,
        code: _codeController.text,
      );
      await resetPassword(resetPasswordCredentials, context);
    }
  }

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
              CustomTextField(
                controller: _codeController,
                label: "Enter the code",
                prefixIcon: FontAwesomeIcons.userSecret,
                isObscure: true,
                isPassword: true,
                validate: ValidateConfirmationCode,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: _passwordController,
                label: "New password",
                prefixIcon: FontAwesomeIcons.lock,
                isObscure: true,
                isPassword: true,
                validate: ValidatePasswordField,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: _rePasswordController,
                label: "Re-Enter New password",
                prefixIcon: FontAwesomeIcons.lock,
                isObscure: true,
                isPassword: true,
                validate: ValidatePasswordField,
              ),
              SizedBox(
                height: 20,
              ),
              CustomAccessButton(
                label: "Save password and login",
                onPressed: () {
                  _submitForm(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomHighlightText(
                    callToActionText: "Go Back",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  CustomHighlightText(
                    callToActionText: "Resend code",
                    onTap: () async {
                      final email = await GetEmail();
                      sendResetCode(email!, context);
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
