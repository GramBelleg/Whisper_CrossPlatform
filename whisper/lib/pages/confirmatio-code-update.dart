// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:whisper/components/custom-highlight-text.dart';
// import 'package:whisper/keys/signup-keys.dart';
// import 'package:whisper/services/email-code-update.dart';
// import 'package:whisper/services/send-confirmation-code.dart';
// import 'package:whisper/services/shared-preferences.dart';
// import 'package:whisper/validators/reset-password-validation/confirmation-code-validation.dart';
// import '../components/custom-access-button.dart';
// import '../components/custom-text-field.dart';
// import '../constants/colors.dart';

// class ConfirmationCodeEmail extends StatefulWidget {
//   final String? email; // Making email nullable

//   const ConfirmationCodeEmail({
//     super.key,
//     this.email,
//   });

//   static String id = "/ConfirmationCodeEmail";

//   @override
//   State<ConfirmationCodeEmail> createState() => _ConfirmationCodeState();
// }

// class _ConfirmationCodeState extends State<ConfirmationCodeEmail> {
//   final TextEditingController _codeController = TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey();

//   void _submitForm(context) async {
//     if (formKey.currentState!.validate()) {
//       await verifyEmailCode(
//           _codeController.text, widget.email as String, context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       builder: (context, snap) {
//         if (snap.connectionState != ConnectionState.waiting) {
//           return Scaffold(
//             backgroundColor: firstNeutralColor,
//             body: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
//               child: Form(
//                 key: this.formKey,
//                 child: ListView(
//                   children: [
//                     Image.asset(
//                       'assets/images/whisper-logo.png',
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     CustomTextField(
//                       key: ValueKey(SignupKeys.codeTextFieldKey),
//                       controller: this._codeController,
//                       label: "أدخل الكود",
//                       prefixIcon: FontAwesomeIcons.userSecret,
//                       isObscure: true,
//                       isPassword: true,
//                       validate: ValidateConfirmationCode,
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     CustomAccessButton(
//                       key: ValueKey(SignupKeys.submitCodeButtonKey),
//                       label: "إرسال الكود",
//                       onPressed: () {
//                         _submitForm(context);
//                       },
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Center(
//                       child: Text(
//                         "تم إرسال الكود إلى: ",
//                         style: TextStyle(
//                           color: secondNeutralColor,
//                         ),
//                       ),
//                     ),
//                     Center(
//                       child: Text(
//                         widget.email as String,
//                         style: TextStyle(
//                           color: secondNeutralColor,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomHighlightText(
//                           key: ValueKey(SignupKeys.goBackFromSubmittingCodeKey),
//                           callToActionText: "رجوع",
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         CustomHighlightText(
//                           key: ValueKey(SignupKeys.resendCodeHighlightTextKey),
//                           callToActionText: "إعادة إرسال الكود",
//                           onTap: () async {
//                             await sendConfirmationCode(
//                                 widget.email as String, context);
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(
//               color: secondNeutralColor,
//               value: 0.5,
//             ),
//           );
//         }
//       },
//       future: null,
//     );
//   }
// }
