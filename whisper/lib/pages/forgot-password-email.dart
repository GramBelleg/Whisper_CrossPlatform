import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/signup-services.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import '../components/custom-access-button.dart';

import '../components/custom-text-field.dart';
import '../constants/colors.dart';

class ForgotPasswordEmail extends StatelessWidget {
  ForgotPasswordEmail({super.key});

  final TextEditingController _emailController = TextEditingController();
  static String id = "/ForgotPasswordEmail";
  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm(context) async {
    if (formKey.currentState!.validate()) {
      print("Form is valid!");
      String email = _emailController.text;
      dynamic userMap = await SignupServices.getUser(email);
      print(userMap);
      if (userMap != null) {
        await SaveEmail(userMap['email']);
        Navigator.pushNamed(context, ConfirmationCode.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No user with this email"),
          duration: Duration(seconds: 2),
        ));
      }
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
                height: 50,
              ),
              CustomTextField(
                controller: this._emailController,
                label: "Email",
                prefixIcon: FontAwesomeIcons.envelope,
                isObscure: false,
                isPassword: false,
                validate: ValidateEmailField,
              ),
              SizedBox(
                height: 50,
              ),
              CustomAccessButton(
                label: "Send Confirmation Code",
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
