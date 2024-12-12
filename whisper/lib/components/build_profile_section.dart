import 'package:flutter/material.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';

class ProfileSection extends StatelessWidget {
  final bool isEditing;
  final bool hasStory;
  final String profilePic;
  final String name;
  final String status;

  final Function()? showImageSourceDialog;
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
                  gradient: !isEditing && hasStory
                      ? const LinearGradient(
                          colors: [Colors.purple, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
                child: InkWell(
                  onTap: () {
                    if (isEditing) {
                      showImageSourceDialog!();
                    } else {
                      if (hasStory) {
                        showProfileOrStatusOptions!();
                      } else {
                        viewProfilePhoto(context, profilePic);
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
                        colorFilter: isEditing
                            ? const ColorFilter.mode(
                                Colors.grey, BlendMode.saturation)
                            : const ColorFilter.mode(
                                Colors.transparent, BlendMode.saturation),
                        child: Image.network(
                          profilePic,
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
              if (isEditing)
                Positioned(
                  child: InkWell(
                    onTap: showImageSourceDialog,
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
          if (!isEditing) ...[
            Text(
              name,
              style: TextStyle(color: secondNeutralColor, fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              status == "Online" ? "Online" : "Offline",
              style: TextStyle(
                color:
                    status == "Online" ? const Color(0xFF4CB9CF) : Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
