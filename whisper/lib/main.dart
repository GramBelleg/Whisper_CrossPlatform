import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/blocked_users_cubit.dart';
import 'package:whisper/components/page-state.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/cubit/visibility_cubit.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/pages/forgot-password-email.dart';
import 'package:whisper/pages/login-with-facebook.dart';
import 'package:whisper/pages/login-with-github.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/logout-after-reset-password.dart';
import 'package:whisper/pages/mainchats.dart';
import 'package:whisper/pages/reset-password.dart';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/services/chat-deletion-service.dart';
import 'package:whisper/services/fetch-messages.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) =>
            MessagesCubit(ChatViewModel(), ChatDeletionService())),
    // BlocProvider(create: (context) => UserCubit()),
    BlocProvider(create: (context) => VisibilityCubit()),
    BlocProvider(create: (context) => BlockedUsersCubit()),
  ], child: Whisper()));
}

class Whisper extends StatefulWidget {
  @override
  _WhisperState createState() => _WhisperState();
}

class _WhisperState extends State<Whisper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Login.id,
      theme: ThemeData(fontFamily: 'ABeeZee'),
      routes: {
        Login.id: (context) => Login(),
        Signup.id: (context) => Signup(),
        ForgotPasswordEmail.id: (context) => ForgotPasswordEmail(),
        ConfirmationCode.id: (context) => ConfirmationCode(),
        ResetPassword.id: (context) => ResetPassword(),
        LoginWithFacebook.id: (context) => LoginWithFacebook(),
        LoginWithGithub.id: (context) => LoginWithGithub(),
        LogoutAfterResetPassword.id: (context) => LogoutAfterResetPassword(),
        MainChats.id: (context) => MainChats(),
        PageState.id: (context) => PageState(),
      },
    );
  }
}
