import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/blocked_users_cubit.dart';
import 'package:whisper/components/page_state.dart';
import 'package:whisper/cubit/messages_cubit.dart';
import 'package:whisper/cubit/visibility_cubit.dart';
import 'package:whisper/global_cubits/global_chats_cubit.dart';
import 'package:whisper/global_cubits/global_setting_cubit.dart';
import 'package:whisper/global_cubits/global_user_story_cubit_provider.dart';
import 'package:whisper/pages/confirmation_code.dart';
import 'package:whisper/pages/forget_password_email.dart';
import 'package:whisper/pages/login_with_git_hub.dart';
import 'package:whisper/pages/login_with_google.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/pages/log_out_after_reset_password.dart';
import 'package:whisper/pages/recaptcha.dart';
import 'package:whisper/pages/main_chats.dart';
import 'package:whisper/pages/reset_password.dart';
import 'package:whisper/pages/sign_up.dart';
import 'package:whisper/services/blocked_users_service.dart';
import 'package:whisper/services/chat_deletion_service.dart';
import 'package:whisper/services/fetch_chat_messages.dart';
import 'package:whisper/services/visibility_service.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => GlobalSettingsCubitProvider.settingsCubit),
    BlocProvider(
        create: (context) =>
            MessagesCubit(ChatViewModel(), ChatDeletionService())),
    BlocProvider(create: (context) => VisibilityCubit(VisibilityService())),
    BlocProvider(create: (context) => BlockedUsersCubit(BlockedUsersService())),
    BlocProvider(
        create: (context) => GlobalUserStoryCubitProvider.userStoryCubit),
    BlocProvider(create: (context) => GlobalChatsCubitProvider.chatListCubit),
  ], child: Whisper()));
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
        Login.id: (context) => Login(),

        ///ConfirmationCodeEmail.id: (context) => ConfirmationCodeEmail()
        // ChatPage.id: (context) => ChatPage(),
      },
    );
  }
}
