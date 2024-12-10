import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/components/app_navigator.dart';
import 'package:whisper/components/tap_bar.dart';
import 'package:whisper/models/user_state.dart';
import 'package:whisper/services/fetch_user_info.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/cubit/settings_cubit.dart';
import 'package:whisper/socket.dart';

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
    SocketService.instance.connectSocket();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    if (!_isUserInfoLoaded) {
      // Only load if not already loaded
      userState = await fetchUserInfo();
      String? urlProfilePic = await generatePresignedUrl(userState!.profilePic);
      userState!.copyWith(profilePic: urlProfilePic);
      await saveUserState(userState!); // save in shared preferences
      _isUserInfoLoaded = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingsCubit()..loadUserState(), // Provide the cubit
      child: Scaffold(
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
