import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      appBar: AppBar(
        title: Text(
          "Blocked Users",
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: firstNeutralColor,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Center(
        child: Text(
          "Blocked Users Content",
          style: TextStyle(color: secondNeutralColor, fontSize: 24),
        ),
      ),
    );
  }
}
