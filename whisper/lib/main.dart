import 'package:flutter/material.dart';
import 'package:whisper/pages/chat-page.dart';

import 'pages/mainchats-page.dart';

void main() {
  runApp(Whisper());
}

class Whisper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainChats.id,
      theme: ThemeData(
        fontFamily: 'ABeeZee',
      ),
      routes: {
        MainChats.id: (context) => MainChats(),
      },
    );
  }
}
