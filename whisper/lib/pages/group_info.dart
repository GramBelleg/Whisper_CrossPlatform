import 'package:flutter/material.dart';
import 'package:whisper/components/build_profile_section.dart';
import 'package:whisper/components/group_members.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/pages/forward_menu.dart';

class GroupInfo extends StatelessWidget {
  final String? profilePicture;
  final String groupName;
  final int groupId;

  GroupInfo(
      {required this.profilePicture,
      required this.groupName,
      required this.groupId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: firstNeutralColor, // AppBar color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () {
            Navigator.pop(context); // Return to the previous screen
          },
        ),
        title: Text('Group Info', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
          color:
              firstSecondaryColor, // Background color for the rest of the screen
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ProfileSection(
                  hasStory: false,
                  showImageSourceDialog: null,
                  showProfileOrStatusOptions: null,
                  profilePic: profilePicture,
                  name: groupName,
                  status: "6",
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ForwardMenu(
                      text: "ADD MEMBERS",
                      onClearSelection: () {},
                      selectedMessageIds: [],
                      isForward: false,
                      groupId: groupId,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity, // Full width
                  color: Colors.transparent, // Background color
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person_add, color: primaryColor, size: 24),
                      SizedBox(width: 15),
                      Text(
                        'Add Members',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: .25,
                indent: 20,
                endIndent: 20,
              ),
              GroupMembers(chatId: groupId)
            ],
          )),
    );
  }
}
