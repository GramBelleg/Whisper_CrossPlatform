import 'package:flutter/material.dart';
import 'package:whisper/components/app_navigator.dart';
import 'package:whisper/components/tap_bar.dart';
import 'package:whisper/global_cubits/global_user_story_cubit_provider.dart';
import 'package:whisper/socket.dart';

class PageState extends StatefulWidget {
  static const String id = '/page_state';
  const PageState({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<PageState> {
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    print("page state");
    SocketService.instance.connectSocket();
    GlobalUserStoryCubitProvider.userStoryCubit.initUsers();
    print("initUsers UserStoryCubit");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
