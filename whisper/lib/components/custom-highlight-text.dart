import 'package:flutter/cupertino.dart';

import '../constants.dart';

class CustomHighlightText extends StatelessWidget {
  CustomHighlightText({required this.callToActionText});

  String? callToActionText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        "$callToActionText",
        style: TextStyle(
          fontSize: 16,
          color: highlightColor,
        ),
      ),
    );
  }
}
