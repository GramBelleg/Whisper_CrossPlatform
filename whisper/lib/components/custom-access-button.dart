import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAccessButton extends StatelessWidget {
  CustomAccessButton({required this.label});

  String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 50,
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primaryColor),
        ),
        child: Text(
          "$label",
          style: TextStyle(
            color: secondNeutralColor,
          ),
        ),
      ),
    );
  }
}
