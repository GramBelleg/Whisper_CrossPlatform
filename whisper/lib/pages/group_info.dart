import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/build_profile_section.dart';
import 'package:whisper/components/group_members.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/pages/forward_menu.dart';
import 'package:whisper/services/group_management_service.dart';

class GroupInfo extends StatefulWidget {
  final String? profilePicture;
  final String groupName;
  final bool isChannel;
  final int groupId;
  final bool isChannelAdmin;
  final bool isGroupAdmin;
  GroupInfo(
      {required this.profilePicture,
      required this.groupName,
      required this.groupId,
      required this.isChannelAdmin,
      required this.isGroupAdmin,
      required this.isChannel});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  bool isPrivate = false;
  int groupMaxSize = 0;

  // function to get group privacy
  void getGroupConfig() async {
    Map<String, dynamic> groupConfig =
        await GroupManagementService().getGroupSettings(widget.groupId);
    setState(() {
      isPrivate = groupConfig['public'] == false;
      groupMaxSize = groupConfig['maxSize'];
    });
  }

  void setGroupPrivacy(bool isPrivate) {
    GroupManagementService().setGroupPrivacy(widget.groupId, isPrivate);
    setState(() {
      this.isPrivate = isPrivate;
    });
  }

  void setgroupMaxSize(int groupMaxSize) {
    GroupManagementService().setGroupMaxSize(widget.groupId, groupMaxSize);
    setState(() {
      this.groupMaxSize = groupMaxSize;
    });
  }

  @override
  void initState() {
    super.initState();
    getGroupConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: firstNeutralColor, // AppBar color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () {
            Navigator.pop(context); // Return to the previous screen
          },
        ),
        title: Text(widget.isChannel ? 'Channel Info' : 'Group Info',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
            color:
                firstNeutralColor, // Background color for the rest of the screen
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ProfileSection(
                    hasStory: false,
                    showImageSourceDialog: null,
                    showProfileOrStatusOptions: null,
                    profilePic: widget.profilePicture,
                    name: widget.groupName,
                    status: "6",
                  ),
                ),
                if (widget.isChannelAdmin || widget.isGroupAdmin || !widget.isChannel) ...[
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ForwardMenu(
                          text: "ADD MEMBERS",
                          onClearSelection: () {},
                          selectedMessageIds: [],
                          isForward: false,
                          groupId: widget.groupId,
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  widget.isGroupAdmin
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // set group privacy using a modal sheet
                              ListTile(
                                leading: Icon(
                                    isPrivate ? Icons.lock : Icons.public,
                                    color: primaryColor),
                                title: Text('Set group privacy'),
                                titleTextStyle: TextStyle(
                                    color: secondNeutralColor, fontSize: 16),
                                subtitle:
                                    Text(isPrivate ? 'Private' : 'Public'),
                                subtitleTextStyle:
                                    TextStyle(color: primaryColor),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          color: firstNeutralColor,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.public,
                                                    color: secondNeutralColor),
                                                title: Text('Public'),
                                                textColor: secondNeutralColor,
                                                onTap: () {
                                                  setGroupPrivacy(false);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.lock,
                                                    color: secondNeutralColor),
                                                title: Text('Private'),
                                                textColor: secondNeutralColor,
                                                onTap: () {
                                                  setGroupPrivacy(true);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                              // then set group max size using a slider
                              ListTile(
                                leading: Icon(Icons.group, color: primaryColor),
                                title: Text('Set group max size'),
                                titleTextStyle: TextStyle(
                                    color: secondNeutralColor, fontSize: 16),
                                subtitle: Text(groupMaxSize.toString()),
                                subtitleTextStyle:
                                    TextStyle(color: primaryColor),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                            color: firstNeutralColor,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: TextField(
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Group Max Size',
                                                      // input text color is white
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    onSubmitted:
                                                        (String value) {
                                                      int? newSize =
                                                          int.tryParse(value);
                                                      if (newSize != null) {
                                                        setgroupMaxSize(
                                                            newSize);
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: .25,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.5, // Constrain the height of the GroupMembers
                    child: GroupMembers(chatId: widget.groupId),
                  ),
                ],
              ],
            )),
      ),
    );
  }
}
