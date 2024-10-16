import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

// Function to build the bottom navigation bar
FlashyTabBar buildBottomNavigationBar(
    int selectedIndex, Function(int) onItemSelected) {
  return FlashyTabBar(
    backgroundColor: const Color(0xFF0A122F),
    selectedIndex: selectedIndex,
    showElevation: true,
    onItemSelected: onItemSelected,
    items: [
      FlashyTabBarItem(
        icon: const Icon(
          Icons.contacts,
          color: Color(0xff8D6AEE),
        ),
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Color(0xff8D6AEE),
          ),
        ),
      ),
      FlashyTabBarItem(
        icon: const Icon(
          Icons.chat,
          color: Color(0xff8D6AEE),
        ),
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Color(0xff8D6AEE),
          ),
        ),
      ),
      FlashyTabBarItem(
        icon: const Icon(
          Icons.settings,
          color: Color(0xff8D6AEE),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xff8D6AEE),
          ),
        ),
      ),
    ],
  );
}
