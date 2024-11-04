import 'package:flutter/material.dart';
import 'package:whisper/components/custom-access-button.dart';
import 'package:whisper/keys/home-keys.dart';

import '../services/log-out-services.dart';

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
              key: ValueKey(HomeKeys.logoutButtonKey),
              label: "Logout",
              onPressed: () async {
                await LogoutService.logoutFromAllDevices(context);
              }),
        ),
      ),
    );
  }
}
