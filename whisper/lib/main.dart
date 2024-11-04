import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/cubit/visibility_cubit.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/pages/forgot-password-email.dart';
import 'package:whisper/pages/login-with-facebook.dart';
import 'package:whisper/pages/login-with-github.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/logout-after-reset-password.dart';
import 'package:whisper/pages/reset-password.dart';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/services/chat-deletion-service.dart';
import 'package:whisper/services/fetch-messages.dart';
import 'package:whisper/components/tap-bar.dart';

import 'components/app-navigator.dart'; // Import your bottom navigation bar

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) =>
            MessagesCubit(ChatViewModel(), ChatDeletionService())),
    // BlocProvider(create: (context) => UserCubit()),
    BlocProvider(create: (context) => VisibilityCubit()),
  ], child: Whisper()));
}

class Whisper extends StatefulWidget {
  const Whisper({super.key});

  @override
  _WhisperState createState() => _WhisperState();
}

class _WhisperState extends State<Whisper> {
  int _selectedIndex = 1; // Default index for the initial screen

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Login.id,
      theme: ThemeData(fontFamily: 'ABeeZee'),
      home: Scaffold(
        bottomNavigationBar: buildBottomNavigationBar(
          _selectedIndex,
          (index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
          },
        ),
        body: AppNavigator.getScreen(_selectedIndex), // Use AppNavigator
      ),
      routes: {
        // Login.id: (context) => Login(),
        // Signup.id: (context) => Signup(),
        // ForgotPasswordEmail.id: (context) => ForgotPasswordEmail(),
        // ConfirmationCode.id: (context) => ConfirmationCode(),
        // ResetPassword.id: (context) => ResetPassword(),
        // LoginWithFacebook.id: (context) => LoginWithFacebook(),
        // LoginWithGithub.id: (context) => LoginWithGithub(),
        // LogoutAfterResetPassword.id: (context) => LogoutAfterResetPassword(),
      },
    );
  }
}
