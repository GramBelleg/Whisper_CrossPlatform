import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({required this.label,this.perfixIcon});

  String? label;
  IconData? perfixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: secondNeutralColor,
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          color: secondNeutralColor.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: Container(
          width: 50, // Custom width
          alignment: Alignment.center,
          child: FaIcon(
            perfixIcon,
            color: secondNeutralColor,
            size: 24,
          ),
        ),
        filled: true,
        fillColor: primaryColor,
      ),
    );
  }
}
