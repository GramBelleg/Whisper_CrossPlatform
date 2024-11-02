import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomAccessButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed; // Accept an onPressed callback

  // Remove formKey from constructor parameters
  const CustomAccessButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 50,
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Use the passed onPressed function
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
              primaryColor), // Correctly set the background color
        ),
        child: Text(
          label,
          style: TextStyle(
            color: secondNeutralColor,
          ),
        ),
      ),
    );
  }
}
