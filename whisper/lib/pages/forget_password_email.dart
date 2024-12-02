import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom_highlight_text.dart';
import 'package:whisper/keys/forgot_password_keys.dart';
import 'package:whisper/validators/form-validation/validate_email_field.dart';
import '../components/custom_access_button.dart';
import '../components/custom_text_field.dart';
import '../constants/colors.dart';
import '../services/reset_password_service.dart';

class ForgotPasswordEmail extends StatelessWidget {
  ForgotPasswordEmail({super.key});

  final TextEditingController _emailController = TextEditingController();
  static String id = "/ForgotPasswordEmail";
  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm(context) async {
    if (formKey.currentState!.validate()) {
      ResetPasswordService.sendResetCode(
        _emailController.text,
        context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid form"),
        ),
      );
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
                key: ValueKey(ForgotPasswordKeys.emailTextFieldKey),
                controller: this._emailController,
                label: "Email",
                prefixIcon: FontAwesomeIcons.envelope,
                isObscure: false,
                isPassword: false,
                validate: validateEmailField,
              ),
              SizedBox(
                height: 50,
              ),
              CustomAccessButton(
                key: ValueKey(ForgotPasswordKeys.sendCodeButtonKey),
                label: "Send Confirmation Code",
                onPressed: () {
                  _submitForm(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                key: ValueKey(ForgotPasswordKeys
                    .goBackFromForgotPasswordHighlightTextKey),
                child: CustomHighlightText(
                  callToActionText: "Go Back",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
