import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-eye-icon.dart';
import 'package:whisper/validators/form-validation/email-field-validation.dart';
import '../constants/colors.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    required this.label,
    this.prefixIcon,
    required this.isObscure,
    required this.isPassword,
    required this.validate,
    this.controller,
  });

  final TextEditingController? controller;
  String? label;
  IconData? prefixIcon;
  bool? isObscure;
  bool? isPassword;
  String? Function(String?) validate;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void updateIsObscure() {
    setState(() {
      this.widget.isObscure = !this.widget.isObscure!;
    });
  }

  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.widget.controller,
      validator: widget.validate,
      obscureText: widget.isObscure!,
      style: TextStyle(
        color: secondNeutralColor,
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: highlightColor,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: highlightColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: highlightColor,
          ), // No red border
        ),
        hintText: widget.label,
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
            widget.prefixIcon,
            color: secondNeutralColor,
            size: 24,
          ),
        ),
        suffixIcon: widget.isPassword!
            ? (widget.isObscure!
                ? CustomEyeIcon(
                    updateIsObscure: updateIsObscure,
                    slash: true,
                  )
                : CustomEyeIcon(
                    updateIsObscure: updateIsObscure,
                    slash: false,
                  ))
            : null,
        filled: true,
        fillColor: primaryColor,
      ),
    );
  }
}
