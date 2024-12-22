import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/tap_bar_keys.dart';

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
          Icons.contacts,
          color: primaryColor,
        ),
        title: const Text(
          key: Key(TapBarKeys.contactsButton),
          'Contacts',
          style: TextStyle(color: primaryColor),
        ),
      ),
      FlashyTabBarItem(
        icon: const Icon(
          key: Key(TapBarKeys.chatsButton),
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
          Icons.settings,
          color: primaryColor,
        ),
        title: const Text(
          key: Key(TapBarKeys.settingsButton),
          'Settings',
          style: TextStyle(color: primaryColor),
        ),
      ),
    ],
  );
}
