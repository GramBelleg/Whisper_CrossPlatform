import 'package:flutter/material.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/settings_page_keys.dart';

class ProfileSection extends StatefulWidget {
  final bool isEditing;
  final bool hasStory;
  final String profilePic;
  final String name;
  final String status;

  final Future<bool> Function()? showImageSourceDialog;
  final Function()? showProfileOrStatusOptions;

  const ProfileSection({
    Key? key,
    this.isEditing = false,
    required this.hasStory,
    required this.profilePic,
    required this.name,
    required this.status,
    this.showImageSourceDialog,
    this.showProfileOrStatusOptions,
  }) : super(key: key);

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool isLoading = false;

  // Function to handle profile picture change
  Future<void> _handleProfilePicChange() async {
    setState(() {
      isLoading = true; // Start loading
    });

    bool success = await widget.showImageSourceDialog!(); // Call the dialog

    setState(() {
      isLoading = false; // Stop loading after the operation is complete
    });

    if (success) {
      // Handle success (optional: show a message)
    } else {
      // Handle failure (optional: show an error)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Circle with border if a story exists
              Container(
                padding: const EdgeInsets.all(3), // Border thickness
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: !widget.isEditing && widget.hasStory
                      ? const LinearGradient(
                          colors: [Colors.purple, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
                child: InkWell(
                  key: SettingsPageKeys.onTapProfilePic,
                  onTap: () {
                    if (widget.isEditing) {
                      _handleProfilePicChange(); // Show image source dialog
                    } else {
                      if (widget.hasStory) {
                        widget.showProfileOrStatusOptions!();
                      } else {
                        viewProfilePhoto(context, widget.profilePic);
                      }
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey,
                    child: ClipOval(
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Colors.transparent, BlendMode.saturation),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    secondNeutralColor),
                              ) // Show loading spinner
                            : Image.network(
                                widget.profilePic,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              // Camera icon overlay with action when in editing mode
              if (widget.isEditing)
                Positioned(
                  child: InkWell(
                    onTap: _handleProfilePicChange,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      Icons.camera_alt,
                      color: secondNeutralColor,
                      size: 40,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (!widget.isEditing) ...[
            Text(
              widget.name,
              style: TextStyle(color: secondNeutralColor, fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              widget.status == "Online" ? "Online" : "Offline",
              style: TextStyle(
                color: widget.status == "Online"
                    ? const Color(0xFF4CB9CF)
                    : Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
