import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.google,
              color: secondNeutralColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.github,
              color: secondNeutralColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.facebook,
              color: secondNeutralColor,
            ),
          ),
        ],
      ),
    );
  }
}
