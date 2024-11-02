import 'package:flutter/material.dart';
import 'package:whisper/components/app-navigator.dart';
import 'package:whisper/components/tap-bar.dart';
import 'package:whisper/components/user-state.dart';
import 'package:whisper/services/get-userinfo.dart';
import 'package:whisper/services/shared-preferences.dart';

class PageState extends StatefulWidget {
  static const String id = '/page_state';
  const PageState({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<PageState> {
  int _selectedIndex = 1;
  UserState? userState;
  bool _isUserInfoLoaded =
      false; // Flag to check if user info is already loaded

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    if (!_isUserInfoLoaded) {
      // Only load if not already loaded
      userState = await fetchUserInfo();
      await saveUserState(userState!); // save in shared performance
      _isUserInfoLoaded = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: buildBottomNavigationBar(
          _selectedIndex,
          (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: AppNavigator.getScreen(
          _selectedIndex,
        ),
      ),
    );
  }
}
