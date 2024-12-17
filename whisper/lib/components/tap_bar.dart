import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

FlashyTabBar buildBottomNavigationBar(
    int selectedIndex, Function(int) onTabSelected) {
  return FlashyTabBar(
    backgroundColor: const Color(0xFF0A122F),
    selectedIndex: selectedIndex,
    showElevation: true,
    onItemSelected: onTabSelected,
    items: [
      FlashyTabBarItem(
        icon: const Icon(
          key: Key("ContactsPageKey"),
          Icons.contacts,
          color: primaryColor,
        ),
        title: const Text(
          'Contacts',
          style: TextStyle(color: primaryColor),
        ),
      ),
      FlashyTabBarItem(
        icon: const Icon(
          key: Key("ChatsPageKey"),
          Icons.chat,
          color: primaryColor,
        ),
        title: const Text(
          'Chats',
          style: TextStyle(color: primaryColor),
        ),
      ),
      FlashyTabBarItem(
        icon: const Icon(
          key: Key("SettingsPageKey"),
          Icons.settings,
          color: primaryColor,
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: primaryColor),
        ),
      ),
    ],
  );
}
