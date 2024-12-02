import 'package:flutter/material.dart';

class ProfilePictureSettingsPage extends StatelessWidget {
  const ProfilePictureSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Picture Settings"),
        backgroundColor: Color(0xFF0A122F),
      ),
      body: Center(
        child: Text(
          "Profile Picture Settings Content",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
