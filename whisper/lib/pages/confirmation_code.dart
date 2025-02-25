import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom_highlight_text.dart';
import 'package:whisper/keys/sign_up_keys.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/sign_up_services.dart';
import 'package:whisper/validators/reset-password-validation/validate_confirmation_code.dart';
import '../components/custom_access_button.dart';
import '../components/custom_text_field.dart';
import '../constants/colors.dart';

class ConfirmationCode extends StatefulWidget {
  const ConfirmationCode({super.key});

  static String id = "/ConfirmationCode";

  @override
  State<ConfirmationCode> createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  final TextEditingController _codeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  void _submitForm(context) async {
    if (formKey.currentState!.validate()) {
      await SignupService.confirmCode(_codeController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEmail(),
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
                      key: ValueKey(SignupKeys.codeTextFieldKey),
                      controller: this._codeController,
                      label: "Enter the code",
                      prefixIcon: FontAwesomeIcons.userSecret,
                      isObscure: true,
                      isPassword: true,
                      validate: validateConfirmationCode,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CustomAccessButton(
                      key: ValueKey(SignupKeys.submitCodeButtonKey),
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
                          key: ValueKey(SignupKeys.goBackFromSubmittingCodeKey),
                          callToActionText: "Go back",
                          onTap: () {
                            Navigator.popUntil(
                                context, ModalRoute.withName('/Signup'));
                          },
                        ),
                        CustomHighlightText(
                          key: ValueKey(SignupKeys.resendCodeHighlightTextKey),
                          callToActionText: "Resend code",
                          onTap: () async {
                            final email = await getEmail();
                            await SignupService.sendConfirmationCode(
                                email!, context);
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
