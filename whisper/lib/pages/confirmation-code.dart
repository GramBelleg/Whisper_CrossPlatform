import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/pages/reset-password.dart';

import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/signup-services.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import 'package:whisper/validators/form-validation/phone-field-validation.dart';
import 'package:whisper/validators/reset-password-validation/confirmation-code-validation.dart';
import '../components/custom-access-button.dart';

import '../components/custom-text-field.dart';
import '../constants/colors.dart';

class ConfirmationCode extends StatefulWidget {
  ConfirmationCode({super.key});

  static String id = "/ConfirmationCode";

  @override
  State<ConfirmationCode> createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  final TextEditingController _codeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm(context) async {
    if (formKey.currentState!.validate()) {
      // this is not an api, this is a function to get the email saved
      // in the shared preferences
      dynamic email = await GetEmail();
      // the next line should be replaced with a real api
      dynamic code = await SignupServices.getConfirmationCodeByEmail(email);
      print(code);
      print(_codeController.text);
      if (_codeController.text == code.toString()) {
        Navigator.pushNamed(context, ResetPassword.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wrong Code"),
            duration: Duration(seconds: 2),
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
                controller: this._codeController,
                label: "Enter the code",
                prefixIcon: FontAwesomeIcons.userSecret,
                isObscure: true,
                isPassword: true,
                validate: ValidateConfirmationCode,
              ),
              SizedBox(
                height: 50,
              ),
              CustomAccessButton(
                label: "Submit Confirmation Code",
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
