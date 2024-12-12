import 'package:flutter/material.dart';
import 'package:whisper/components/build_profile_section.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/models/user_state.dart';

class ProfilePage extends StatelessWidget {
  final bool hasStory;
  final String profilePic;
  final String name;
  final String status; // if you want to add # of members

  final Function()? showImageSourceDialog;
  final Function()? showProfileOrStatusOptions;

  const ProfilePage({
    Key? key,
    required this.hasStory,
    required this.profilePic,
    required this.name,
    this.status = '', // defult
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
        profilePic: profilePic,
        name: name,
        status: "status",
        showImageSourceDialog: null,
        showProfileOrStatusOptions: null,
      ),
    );
  }
}
