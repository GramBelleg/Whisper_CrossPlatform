import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/pages/login_with_git_hub.dart';
import 'package:whisper/pages/login_with_google.dart';

import '../constants/colors.dart';

class CustomQuickLogin extends StatelessWidget {
  const CustomQuickLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: firstSecondaryColor,
          borderRadius: BorderRadius.all(Radius.circular((16)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginWithGoogle.id);
            },
            child: FaIcon(
              key: ValueKey(LoginKeys.googleLoginIconKey),
              FontAwesomeIcons.google,
              color: secondNeutralColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginWithGithub.id);
            },
            child: FaIcon(
              key: ValueKey(LoginKeys.githubLoginIconKey),
              FontAwesomeIcons.github,
              color: secondNeutralColor,
            ),
          ),
        ],
      ),
    );
  }
}
