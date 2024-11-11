import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/components/app-navigator.dart';
import 'package:whisper/components/tap-bar.dart';
import 'package:whisper/components/user-state.dart';
import 'package:whisper/services/get-userinfo.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/cubit/profile-setting-cubit.dart';
import 'package:whisper/socket.dart'; // Import your SettingsCubit

// this file to put the 3 screens and navigate with them
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
    var token =
        await GetToken(); // Make sure GetToken is awaited to fetch the token
    print("dammmmmmmmmn$token");
    // Pass the token to connectSocket
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
    SocketService.instance.initSocket();
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
