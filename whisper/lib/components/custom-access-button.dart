import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomAccessButton extends StatelessWidget {
  CustomAccessButton({required this.label, required this.formKey});

  String? label;
  GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 50,
      ),
      child: ElevatedButton(
        onPressed: () {
          if (formKey!.currentState!.validate()) {
          } else {
            print("Wrong");
          }
        },
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
