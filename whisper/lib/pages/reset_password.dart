import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom_highlight_text.dart';
import 'package:whisper/models/reset_password_credentials.dart';
import 'package:whisper/services/reset_password_service.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/validators/form-validation/validate_passward_field.dart';
import 'package:whisper/validators/form-validation/validate_similar_passwords.dart';
import 'package:whisper/validators/reset-password-validation/validate_confirmation_code.dart';
import '../components/custom_access_button.dart';
import '../components/custom_text_field.dart';
import '../constants/colors.dart';
import '../keys/forgot_password_keys.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  static String id = "/ResetPassword";
  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm(context) async {
    if (formKey.currentState!.validate()) {
      if (validateSimilarPasswords(
          _passwordController.text, _rePasswordController.text)) {
        ResetPasswordCredentials resetPasswordCredentials =
            ResetPasswordCredentials(
          password: _passwordController.text,
          confirmPassword: _rePasswordController.text,
          code: _codeController.text,
        );
        await ResetPasswordService.resetPassword(
            resetPasswordCredentials, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords are not similar'),
          ),
        );
      }
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
                key: ValueKey(ForgotPasswordKeys.codeTextFieldKey),
                controller: _codeController,
                label: "Enter the code",
                prefixIcon: FontAwesomeIcons.userSecret,
                isObscure: true,
                isPassword: true,
                validate: validateConfirmationCode,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                key: ValueKey(ForgotPasswordKeys.passwordTextFieldKey),
                controller: _passwordController,
                label: "New password",
                prefixIcon: FontAwesomeIcons.lock,
                isObscure: true,
                isPassword: true,
                validate: validatePasswordField,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                key: ValueKey(ForgotPasswordKeys.rePasswordTextFieldKey),
                controller: _rePasswordController,
                label: "Re-Enter New password",
                prefixIcon: FontAwesomeIcons.lock,
                isObscure: true,
                isPassword: true,
                validate: validatePasswordField,
              ),
              SizedBox(
                height: 20,
              ),
              CustomAccessButton(
                key: ValueKey(ForgotPasswordKeys.savePasswordAndLoginButtonKey),
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
                    key: ValueKey(ForgotPasswordKeys
                        .goBackFromCodeAndPasswordsHighlightTextKey),
                    callToActionText: "Go Back",
                    onTap: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/ForgotPasswordEmail'));
                    },
                  ),
                  CustomHighlightText(
                    key:
                        ValueKey(ForgotPasswordKeys.resendCodeHighlightTextKey),
                    callToActionText: "Resend code",
                    onTap: () async {
                      final email = await getEmail();
                      await ResetPasswordService.sendResetCode(email!, context);
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
