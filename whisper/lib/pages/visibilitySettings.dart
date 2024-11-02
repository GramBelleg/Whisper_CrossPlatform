import 'package:flutter/material.dart';

class VisibilitySettingsPage extends StatelessWidget {
  const VisibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visibility Settings"),
        backgroundColor: Color(0xFF0A122F),
      ),
      body: Center(
        child: Text(
          "Visibility Settings Content",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
