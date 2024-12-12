import 'package:flutter/material.dart';
import 'package:whisper/components/build_profile_section.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/models/user_state.dart';

class ProfilePage extends StatelessWidget {
  final bool hasStory;
  final String profilePic;
  final String username;
  final UserState? userState;
  final Function()? showImageSourceDialog;
  final Function()? showProfileOrStatusOptions;

  const ProfilePage({
    Key? key,
    required this.hasStory,
    required this.profilePic,
    required this.username,
    required this.userState,
    this.showImageSourceDialog,
    this.showProfileOrStatusOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile'),
        backgroundColor: highlightColor, // Customize as needed
      ),
      body: ProfileSection(
        hasStory: hasStory,
        profilePicState: profilePic,
        usernameState: username,
        userState: userState,
        showImageSourceDialog: null,
        showProfileOrStatusOptions: null,
      ),
    );
  }
}
