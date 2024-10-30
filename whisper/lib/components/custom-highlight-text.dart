import 'package:flutter/cupertino.dart';

import '../constants/colors.dart';

class CustomHighlightText extends StatelessWidget {
  CustomHighlightText({
    super.key,
    required this.callToActionText,
    this.onTap,
  });

  String? callToActionText;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
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
