import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blocked Users"),
        backgroundColor: Color(0xFF0A122F),
      ),
      body: Center(
        child: Text(
          "Blocked Users Content",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
