import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum VisibilityStates { everyone, myContacts, nobody }

class VisibilitySettingsPage extends StatefulWidget {
  const VisibilitySettingsPage({super.key});

  @override
  State<VisibilitySettingsPage> createState() => _VisibilitySettingsPageState();
}

class _VisibilitySettingsPageState extends State<VisibilitySettingsPage> {
  // VisibilityStates _profilePictureVisibility = VisibilityStates.everyone;
  // VisibilityStates _lastSeenVisibility = VisibilityStates.everyone;
  // VisibilityStates _storiesVisibility = VisibilityStates.everyone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A122F),
      appBar: AppBar(
        title: Text(
          "Visibility Settings",
          style: TextStyle(color: Color(0xff8D6AEE)),
        ),
        backgroundColor: Color(0xFF0A122F),
        iconTheme: IconThemeData(color: Color(0xff8D6AEE)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Who can see my profile picture?",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Everyone",
                  style: TextStyle(color: Color(0xff8D6AEE).withOpacity(0.6)),
                )
              ],
            ),
            onTap: () {
              if (kDebugMode) print("profile picture visibility");
            },
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Who can see my stories?",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Everyone",
                  style: TextStyle(color: Color(0xff8D6AEE).withOpacity(0.6)),
                )
              ],
            ),
            onTap: () {
              if (kDebugMode) print("stories visibility");
            },
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Who can see my last seen?",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Everyone",
                  style: TextStyle(color: Color(0xff8D6AEE).withOpacity(0.6)),
                )
              ],
            ),
            onTap: () {
              if (kDebugMode) print("last seen visibility");
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Read Receipts",
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: true,
                  onChanged: (bool value) {
                    if (kDebugMode) print("read receipts");
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
