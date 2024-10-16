import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-phone-field.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/signup-services.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import 'package:whisper/validators/form-validation/repassword-signup-validation.dart';
import '../components/custom-access-button.dart';
import '../components/custom-highlight-text.dart';
import '../components/custom-text-field.dart';
import '../constants/colors.dart';
import '../modules/user.dart';
import '../validators/form-validation/password-field-validation.dart';

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
  final TextEditingController phoneController = TextEditingController();

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      if (!ValidateRePassword(
        passwordController.text,
        rePasswordController.text,
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Passwords aren't the same"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        User user = User(
          email: emailController.text,
          password: passwordController.text,
          phone: phoneController.text,
        );
        try {
          await SignupServices.addUser(user);
        } catch (e) {
          print(e);
        }
      }

      // Perform signup logic here
    } else {
      print("Form is invalid!");
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
        child: Form(
          key: formKey,
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
                controller: emailController, // Pass the controller
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
                controller: passwordController, // Pass the controller
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
                controller: rePasswordController, // Pass the controller
              ),
              SizedBox(
                height: 10,
              ),
              CustomPhoneField(
                controller: phoneController, // Pass the controller
              ),
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
