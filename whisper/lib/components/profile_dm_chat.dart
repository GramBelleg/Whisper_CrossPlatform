import 'package:flutter/material.dart';
import 'package:whisper/components/build_profile_section.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/components/info_row.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/services/fetch_user_info.dart';

class ProfileDMChat extends StatefulWidget {
  final int id;

  const ProfileDMChat({
    super.key,
    required this.id,
  });

  @override
  _ProfileDMChatState createState() => _ProfileDMChatState();
}

class _ProfileDMChatState extends State<ProfileDMChat> {
  String profilePicState = "";
  String nameState = "";
  String phoneNumberState = "";
  String usernameState = "";
  String emailState = "";
  String bioState = "";
  String status = "";
  bool isLoading = true; // To handle loading state
  bool isError = false; // To handle error state

  @override
  void initState() {
    super.initState();
    fetchAndSetProfileData(
        widget.id); // Fetch the data when the widget is initialized
  }

  Future<void> fetchAndSetProfileData(int id) async {
    final data = await fetchProfileData(id);

    if (data != null) {
      setState(() {
        profilePicState = data['profilePicUrl'] ??
            "https://ui-avatars.com/api/?background=0a122f&size=1500&color=fff&name=${formatName(data['userName'])}";
        nameState = data['name'] ?? '';
        phoneNumberState = data['phoneNumber'] ?? '';
        usernameState = data['userName'] ?? '';
        bioState = data['bio'] ?? '';
        status = data['status'] ?? '';
        isLoading = false;
        isError = false; // Reset error state on success
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true; // Set error state if data is null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator while data is being fetched
      return Scaffold(
        backgroundColor: firstSecondaryColor, // Set your primary color here
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isError) {
      // Show error message with Go Back button
      return Scaffold(
        backgroundColor: firstSecondaryColor, // Set your primary color here
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Info not available",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextButton(
                key: const Key('popScreenButton'),
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Use secondary neutral color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: primaryColor, // Use secondary color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show the profile details when data is available
    return Scaffold(
      backgroundColor: firstSecondaryColor, // Set your primary color here
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              ProfileSection(
                isEditing: false,
                hasStory: false,
                profilePic: profilePicState,
                name: nameState,
                status: status,
                showImageSourceDialog: null,
                showProfileOrStatusOptions: null,
              ),
              SizedBox(height: 30),
              InfoRow(
                  value: phoneNumberState, label: 'Phone', icon: Icons.phone),
              InfoRow(
                  value: usernameState, label: 'Username', icon: Icons.person),
              InfoRow(value: bioState, label: 'Bio', icon: Icons.person_sharp),
            ],
          ),
        ),
      ),
    );
  }
}
