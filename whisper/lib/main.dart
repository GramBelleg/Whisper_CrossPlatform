import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whisper/components/custom-access-button.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/components/custom-quick-login.dart';
import 'package:whisper/components/custom-text-field.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/file-message-cubit.dart';
import 'package:whisper/cubit/blocked_users_cubit.dart';
import 'package:whisper/components/page-state.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/cubit/profile-setting-cubit.dart';
import 'package:whisper/cubit/stories-cubit.dart';
import 'package:whisper/cubit/visibility_cubit.dart';
import 'package:whisper/pages/confirmation-code.dart';
import 'package:whisper/pages/forgot-password-email.dart';
import 'package:whisper/pages/login-with-github.dart';
import 'package:whisper/pages/login-with-google.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/logout-after-reset-password.dart';
import 'package:whisper/pages/recaptcha.dart';
import 'package:whisper/pages/mainchats.dart';
import 'package:whisper/pages/reset-password.dart';
import 'package:whisper/pages/signup.dart';
import 'package:whisper/services/blocked_users_service.dart';
import 'package:whisper/services/chat-deletion-service.dart';
import 'package:whisper/services/fetch-messages.dart';
import 'package:whisper/services/friend-service.dart';
import 'package:whisper/view-models/forward-menu-view-model.dart';
import 'package:whisper/services/user-stories-service.dart';
import 'package:whisper/services/visibility_service.dart';

void main() {
  runApp(MultiBlocProvider(child: Whisper(), providers: [
    BlocProvider(create: (context) => SettingsCubit()),

    BlocProvider(
        create: (context) =>
            MessagesCubit(ChatViewModel(), ChatDeletionService())),
    // BlocProvider(create: (context) => UserCubit()),
    BlocProvider(create: (context) => VisibilityCubit(VisibilityService())),
    BlocProvider(create: (context) => BlockedUsersCubit(BlockedUsersService())),
    BlocProvider(create: (context) => UserStoryCubit(UserStoriesService())),
  ]));
}

class UserStoryService {}

class Whisper extends StatefulWidget {
  @override
  _WhisperState createState() => _WhisperState();
  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

  Whisper({super.key});
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
        LoginWithGithub.id: (context) => LoginWithGithub(),
        LogoutAfterResetPassword.id: (context) => LogoutAfterResetPassword(),
        MainChats.id: (context) => MainChats(),
        PageState.id: (context) => PageState(),
        Recaptcha.id: (context) => Recaptcha(
              apiKey: "6Lc1eGIqAAAAAGOSheGWYAKiGSZfgWqbOm2X1BdP",
              controller: RecaptchaV2Controller(),
              onVerifiedError: (err) {
                print(err);
              },
              onVerifiedSuccessfully: (success) {
                if (success) Navigator.pushNamed(context, Signup.id);
              },
            ),
        LoginWithGoogle.id: (context) => LoginWithGoogle(),

        ///ConfirmationCodeEmail.id: (context) => ConfirmationCodeEmail()
        // ChatPage.id: (context) => ChatPage(),
      },
    );
  }
}
