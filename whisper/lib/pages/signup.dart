import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-phone-field.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import '../components/custom-access-button.dart';
import '../components/custom-highlight-text.dart';
import '../components/custom-text-field.dart';
import '../constants/colors.dart';
import '../validators/form-validation/password-field-validation.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  static String id = "/Signup";

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
              CustomTextField(
                label: "Re-Password",
                prefixIcon: FontAwesomeIcons.lock,
                isObscure: true,
                isPassword: true,
                validate: ValidatePasswordField,
              ),
              SizedBox(
                height: 10,
              ),
              CustomPhoneField(),
              SizedBox(
                height: 10,
              ),
              CustomAccessButton(
                label: "Signup",
                onPressed: _submitForm,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Already a member? ',
                    style: TextStyle(
                      color: secondNeutralColor,
                    ),
                  ),
                  CustomHighlightText(
                    callToActionText: "Login",
                    onTap: () {
                      Navigator.pushNamed(context, Login.id);
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
