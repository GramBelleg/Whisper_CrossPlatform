import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom_phone_field.dart';
import 'package:whisper/keys/sign_up_keys.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/recaptcha.dart';
import 'package:whisper/validators/form-validation/validate_email_field.dart';
import 'package:whisper/validators/form-validation/validate_name_field.dart';
import 'package:whisper/validators/form-validation/validate_similar_passwords.dart';
import 'package:whisper/validators/form-validation/validate_user_name_field.dart';
import '../components/custom_access_button.dart';
import '../components/custom_highlight_text.dart';
import '../components/custom_text_field.dart';
import '../constants/colors.dart';
import '../controllers/custom_phone_controller.dart';
import '../models/sign_up_credentials.dart';
import '../services/show_loading_dialog.dart';
import '../validators/form-validation/validate_passward_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  static String id = "/Signup";

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  // TextEditingControllers for each input field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final CustomPhoneController phoneController = CustomPhoneController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  // FocusNodes for each field to listen for focus changes
  final FocusNode emailFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode rePasswordFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  void _submitForm() async {
    showLoadingDialog(context);
    if (formKey.currentState!.validate()) {
      if (!validateSimilarPasswords(
          passwordController.text, rePasswordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'The two passwords are not similar',
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        SignupCredentials user = SignupCredentials(
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: rePasswordController.text,
          name: nameController.text,
          userName: userNameController.text,
          phoneNumber: phoneController.getFullPhoneNumber(),
        );
        Navigator.pop(context);

        Navigator.pushNamed(context, Recaptcha.id, arguments: user);
      }
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form is invalid'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    emailFocus.addListener(() => _scrollToFocusedField(emailFocus));
    nameFocus.addListener(() => _scrollToFocusedField(nameFocus));
    usernameFocus.addListener(() => _scrollToFocusedField(usernameFocus));
    passwordFocus.addListener(() => _scrollToFocusedField(passwordFocus));
    rePasswordFocus.addListener(() => _scrollToFocusedField(rePasswordFocus));
    phoneFocus.addListener(() => _scrollToFocusedField(phoneFocus));
  }

  void _scrollToFocusedField(FocusNode focusNode) {
    if (focusNode.hasFocus && scrollController.hasClients) {
      final RenderObject? object = focusNode.context?.findRenderObject();
      if (object != null) {
        final RenderAbstractViewport viewport =
            RenderAbstractViewport.of(object);
        final double offset =
            viewport.getOffsetToReveal(object as RenderObject, 0.3).offset;
        print('Scrolling to top offset: $offset'); // Debug log
        scrollController.animateTo(
          offset,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    phoneController.dispose();
    userNameController.dispose();
    nameController.dispose();
    emailFocus.dispose();
    nameFocus.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    rePasswordFocus.dispose();
    phoneFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/whisper-logo.png',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      key: ValueKey(SignupKeys.emailTextFieldKey),
                      label: "Email",
                      prefixIcon: FontAwesomeIcons.envelope,
                      isObscure: false,
                      isPassword: false,
                      validate: validateEmailField,
                      controller: emailController,
                      focusNode: emailFocus,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      key: ValueKey(SignupKeys.nameTextFieldKey),
                      label: "Name",
                      prefixIcon: FontAwesomeIcons.signature,
                      isObscure: false,
                      isPassword: false,
                      validate: validateNameField,
                      controller: nameController,
                      focusNode: nameFocus,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      key: ValueKey(SignupKeys.usernameTextFieldKey),
                      label: "User Name",
                      prefixIcon: FontAwesomeIcons.user,
                      isObscure: false,
                      isPassword: false,
                      validate: validateUsernameField,
                      controller: userNameController,
                      focusNode: usernameFocus,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      key: ValueKey(SignupKeys.passwordTextFieldKey),
                      label: "Password",
                      prefixIcon: FontAwesomeIcons.lock,
                      isObscure: true,
                      isPassword: true,
                      validate: validatePasswordField,
                      controller: passwordController,
                      focusNode: passwordFocus,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      key: ValueKey(SignupKeys.rePasswordTextFieldKey),
                      label: "Re-Password",
                      prefixIcon: FontAwesomeIcons.lock,
                      isObscure: true,
                      isPassword: true,
                      validate: validatePasswordField,
                      controller: rePasswordController,
                      focusNode: rePasswordFocus,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomPhoneField(
                      key: ValueKey(SignupKeys.phoneNumberFieldKey),
                      controller: phoneController,
                      focusNode: phoneFocus,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CustomAccessButton(
                      key: ValueKey(SignupKeys.goToRecaptchaButtonKey),
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
                          key: ValueKey(
                              SignupKeys.goBackToLoginHighlightTextKey),
                          callToActionText: "Login",
                          onTap: () {
                            Navigator.pop(context, Login.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
