import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';

class CustomEyeIcon extends StatelessWidget {
  CustomEyeIcon({required this.updateIsObscure, required this.slash});

  void Function() updateIsObscure;
  bool slash;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, // Custom width
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: this.updateIsObscure,
        child: FaIcon(
          this.slash ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
          color: secondNeutralColor,
          size: 24,
        ),
      ),
    );
  }
}
