import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-phone-field.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/recaptcha.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/signup-services.dart';
import 'package:whisper/services/signup.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import 'package:whisper/validators/form-validation/name-field-validation.dart';
import 'package:whisper/validators/form-validation/repassword-signup-validation.dart';
import 'package:whisper/validators/form-validation/similar-passwords-validation.dart';
import 'package:whisper/validators/form-validation/username-field-validation.dart';
import '../components/custom-access-button.dart';
import '../components/custom-highlight-text.dart';
import '../components/custom-text-field.dart';
import '../constants/colors.dart';
import '../controllers/phone-number-controller.dart';
import '../modules/signup-credentials.dart';
import '../validators/form-validation/password-field-validation.dart';
import '../validators/form-validation/validate-name-with-api.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  static String id = "/Signup";

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formKey = GlobalKey();

  // TextEditingControllers for each input field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final CustomPhoneController phoneController = CustomPhoneController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      if (!ValidateSimilarPasswords(
          passwordController.text, rePasswordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'The two passwords are not similar',
            ),
          ),
        );
      } else {
        NameValidationResult result = await ValidateNameWithAPI(nameController.text);
        if(result.isValid)
          {
            SignupCredentials user = SignupCredentials(
              email: emailController.text,
              password: passwordController.text,
              confirmPassword: rePasswordController.text,
              name: nameController.text,
              userName: userNameController.text,
              phoneNumber: phoneController.getFullPhoneNumber(),
            );
            await SaveSignupCredentials(user);
            Navigator.pushNamed(context, Recaptcha.id);
          }
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Enter your real name',
                ),
              ),
            );
          }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form is invalid'),
        ),
      );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Image.asset(
                'assets/images/whisper-logo.png',
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                label: "Email",
                prefixIcon: FontAwesomeIcons.envelope,
                isObscure: false,
                isPassword: false,
                validate: ValidateEmailField,
                controller: emailController,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                label: "Name",
                prefixIcon: FontAwesomeIcons.signature,
                isObscure: false,
                isPassword: false,
                validate: ValidateNameField,
                controller: nameController,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                label: "User Name",
                prefixIcon: FontAwesomeIcons.user,
                isObscure: false,
                isPassword: false,
                validate: ValidateUsernameField,
                controller: userNameController,
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
                controller: passwordController,
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
                controller: rePasswordController,
              ),
              SizedBox(
                height: 10,
              ),
              CustomPhoneField(
                controller: phoneController, // Pass the custom controller
              ),
              SizedBox(
                height: 5,
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
