import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/signup-services.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import 'package:whisper/validators/form-validation/password-field-validation.dart';
import '../components/custom-access-button.dart';

import '../components/custom-text-field.dart';
import '../constants/colors.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final TextEditingController _passwordController = TextEditingController();
  static String id = "/ResetPassword";
  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm(context) async {
    if (formKey.currentState!.validate()) {
    //   todo : call an api to save the new password and
    //   login
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
                height: 50,
              ),
              CustomTextField(
                controller: this._passwordController,
                label: "New password",
                prefixIcon: FontAwesomeIcons.lock,
                isObscure: true,
                isPassword: true,
                validate: ValidatePasswordField,
              ),
              SizedBox(
                height: 50,
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
            ],
          ),
        ),
      ),
    );
  }
}
