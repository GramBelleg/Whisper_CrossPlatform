import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-access-button.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/components/custom-quick-login.dart';
import 'package:whisper/components/custom-text-field.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/pages/forgot-password-email.dart';
import 'package:whisper/pages/login-with-facebook.dart';
import 'package:whisper/pages/login-with-github.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/logout-after-reset-password.dart';
import 'package:whisper/pages/mainchats-page.dart';
import 'package:whisper/pages/reset-password.dart';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/services/chat-deletion-service.dart';
import 'package:whisper/services/fetch-messages.dart';
import 'package:whisper/services/friend-service.dart';
import 'package:whisper/view-models/forward-menu-view-model.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        // Provide the MessagesCubit first
        BlocProvider(
          create: (context) =>
              MessagesCubit(ChatViewModel(), ChatDeletionService()),
        ),
        // Provide the ForwardMenuCubit using the existing MessagesCubit
        BlocProvider(
          create: (context) => ForwardMenuCubit(
            FriendService(),
            context.read<MessagesCubit>(), // Reuse the MessagesCubit instance
          ),
        ),
      ],
      child: Whisper(),
    ),
  );
}

class Whisper extends StatelessWidget {
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
      },
      // Uncomment this line if you want to set a default page
      // home: LoginWithFacebook(),
    );
  }
}
