import 'package:flutter/material.dart';
import 'package:whisper/components/custom-access-button.dart';

import '../services/logout-all-devices.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static const String id = "/ChatPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          child: CustomAccessButton(
              label: "Logout",
              onPressed: () async {
                await logoutFromAllDevices(context);
              }),
        ),
      ),
    );
  }
}
