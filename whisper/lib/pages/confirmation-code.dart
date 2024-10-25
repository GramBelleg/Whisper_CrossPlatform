import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/services/confirm-code.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/validators/reset-password-validation/confirmation-code-validation.dart';
import '../components/custom-access-button.dart';
import '../components/custom-text-field.dart';
import '../constants/colors.dart';
import '../services/send-confirmation-code.dart';

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
      await confirmCode(_codeController.text, context);
    }
  }

  //todo: make it future builder
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetEmail(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: firstNeutralColor,
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
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
                    Center(
                      child: Text(
                        "Sent code to: ",
                        style: TextStyle(
                          color: secondNeutralColor,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${snap.data}',
                        style: TextStyle(
                          color: secondNeutralColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomHighlightText(
                          callToActionText: "Go back",
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        CustomHighlightText(
                          callToActionText: "Resend code",
                          onTap: () async {
                            final email = await GetEmail();
                            await sendConfirmationCode(email!, context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: secondNeutralColor,
              value: 0.5,
            ),
          );
        }
      },
    );
  }
}
