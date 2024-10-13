import 'package:flutter/material.dart';
import 'package:whisper/pages/chat-page.dart';

void main() {
  runApp(Whisper());
}

class Whisper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: ChatPage.id,
      theme: ThemeData(
        fontFamily: 'ABeeZee',
      ),
      routes: {
        ChatPage.id: (context) => ChatPage(),
      },
    );
  }
}
