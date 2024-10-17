import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/pages/forgot-password-email.dart';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import '../components/custom-access-button.dart';
import '../components/custom-highlight-text.dart';
import '../components/custom-quick-login.dart';
import '../components/custom-text-field.dart';
import '../constants/colors.dart';
import '../validators/form-validation/password-field-validation.dart';

class Login extends StatelessWidget {
  Login({super.key});

  static String id = "/Login";
  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      print("Form is valid!");
    } else {
      print("Form is invalid!");
    }
  }

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
                height: 20,
              ),
              CustomTextField(
                label: "Email",
                prefixIcon: FontAwesomeIcons.envelope,
                isObscure: false,
                isPassword: false,
                validate: ValidateEmailField,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                label: "Password",
                prefixIcon: FontAwesomeIcons.lock,
                isObscure: true,
                isPassword: true,
                validate: ValidatePasswordField,
              ),
              SizedBox(
                height: 10,
              ),
              CustomAccessButton(
                label: "Login",
                onPressed: _submitForm,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CustomHighlightText(
                  callToActionText: 'Forgot Password?',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ForgotPasswordEmail.id,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Don\'t have an acoount?',
                    style: TextStyle(
                      color: secondNeutralColor,
                    ),
                  ),
                  CustomHighlightText(
                    callToActionText: "Register",
                    onTap: () {
                      Navigator.pushNamed(context, Signup.id);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Center(
                child: Text(
                  'Or you can login using: ',
                  style: TextStyle(
                    color: secondNeutralColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomQuickLogin(),
            ],
          ),
        ),
      ),
    );
  }
}
