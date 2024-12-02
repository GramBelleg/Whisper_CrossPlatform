import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/page_state.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/models/login_credentials.dart';
import 'package:whisper/pages/forget_password_email.dart';
import 'package:whisper/pages/sign_up.dart';
import 'package:whisper/validators/form-validation/validate_email_field.dart';
import '../components/custom_access_button.dart';
import '../components/custom_highlight_text.dart';
import '../components/custom_quick_login.dart';
import '../components/custom_text_field.dart';
import '../constants/colors.dart';
import '../services/login_service.dart';
import '../validators/form-validation/validate_passward_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static String id = "/Login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  Future<bool?>? loginStatusFuture;

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      print("Form is valid!");
      LoginCredentials loginCred = LoginCredentials(
        email: emailController.text,
        password: passwordController.text,
      );
      await LoginService.login(loginCred, context);
    } else {
      print("Form is invalid!");
    }
  }

  @override
  void initState() {
    super.initState();
    loginStatusFuture = _checkLoginStatus();
  }

  Future<bool?> _checkLoginStatus() async {
    return await LoginService.checkAlreadyLoggedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginStatusFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.waiting) {
          if (snap.hasData && snap.data != null && !snap.data!) {
            return Scaffold(
              backgroundColor: firstNeutralColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 32.0,
                ),
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
                        key: const ValueKey(LoginKeys.emailTextFieldKey),
                        controller: this.emailController,
                        label: "Email",
                        prefixIcon: FontAwesomeIcons.envelope,
                        isObscure: false,
                        isPassword: false,
                        validate: validateEmailField,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        key: const ValueKey(LoginKeys.passwordTextFieldKey),
                        controller: passwordController,
                        label: "Password",
                        prefixIcon: FontAwesomeIcons.lock,
                        isObscure: true,
                        isPassword: true,
                        validate: validatePasswordField,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomAccessButton(
                        key: const ValueKey(LoginKeys.loginButtonKey),
                        label: "Login",
                        onPressed: _submitForm,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: CustomHighlightText(
                          key: const ValueKey(
                              LoginKeys.forgotPasswordHighlightText),
                          callToActionText: 'Forgot Password?',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ForgotPasswordEmail.id,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: secondNeutralColor,
                            ),
                          ),
                          CustomHighlightText(
                            key: const ValueKey(
                                LoginKeys.registerHighLightTextKey),
                            callToActionText: "Register",
                            onTap: () {
                              Navigator.pushNamed(context, Signup.id);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: Text(
                          'Or you can login using: ',
                          style: TextStyle(
                            color: secondNeutralColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomQuickLogin(),
                    ],
                  ),
                ),
              ),
            );
          } else if (snap.hasData && snap.data != null && snap.data!) {
            return PageState();
            //todo: this should be replaced with the real chat page
          }
          return Scaffold(
            body: Center(
              child: Text("Run the backend first"),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading"),
                  SizedBox(height: 20),
                  CircularProgressIndicator(), // Add a loading indicator under the logo
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
