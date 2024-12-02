import 'package:flutter/material.dart';
// import '../screens/contacts_screen.dart'; // Import your screens here
// import '../screens/chats_screen.dart';
import '../pages/contacts.dart';
import '../pages/mainchats.dart';
import '../pages/setting.dart';

class AppNavigator {
  static Widget getScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return ContactsPage(); // Change to your Contacts screen
      case 1:
        return const MainChats(); // Change to your Chats screen
      case 2:
        return SettingsPage(); // Change to your Settings screen
      default:
        return const MainChats();
    }
  }
}
