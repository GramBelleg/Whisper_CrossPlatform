import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom-access-button.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/components/custom-quick-login.dart';
import 'package:whisper/components/custom-text-field.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/pages/login.dart';

void main() {
  runApp(Whisper());
}

class Whisper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Login.id,
      theme: ThemeData(fontFamily: 'ABeeZee'),
      routes: {
        Login.id: (context) => Login(),
      },
      home: Login(),
    );
  }
}
