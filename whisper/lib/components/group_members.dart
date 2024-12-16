import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/groups_cubit.dart';
import 'package:whisper/cubit/groups_cubit_state.dart';
import 'package:whisper/global_cubits/global_groups_provider.dart';
import 'package:whisper/models/group_member.dart';
import 'package:whisper/services/fetch_chat_members.dart';
import 'package:whisper/models/user.dart'; // Ensure this import points to your User model
import 'package:whisper/services/shared_preferences.dart';
import 'group_member_card.dart'; // Import the GroupMemberCard widget

class GroupMembers extends StatefulWidget {
  final int chatId;

  const GroupMembers({
    super.key,
    required this.chatId,
  });

  @override
  _GroupMembersState createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  bool _isLoading = true;
  List<GroupMember> _membersList = [];
  String _errorMessage = '';
  bool _isAdmin = false;

  // Async function to load members
  Future<void> _loadMembers() async {
    try {
      _membersList = await fetchChatMembers(widget.chatId);
      print("_membersList: $_membersList");
      int? id = await getId();
      setState(() {
        _isLoading = false;
        for (var member in _membersList) {
          if (member.id == id && member.isAdmin == true) {
            _isAdmin = true;
            break;
          }
        }
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMembers(); // Call the async method to load the members when the widget is initialized
  }

  // Helper function to format lastSeen time as hours and minutes
  String _formatLastSeen(DateTime lastSeen) {
    int hours = lastSeen.hour % 12;
    int minutes = lastSeen.minute % 60;

    return '$hours:$minutes';
  }

  void _showPopupMenu(
      BuildContext context, GroupMember member, GlobalKey key) async {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position =
        renderBox.localToGlobal(Offset.zero); // Get the position of the widget

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx + 10, position.dy + 10, 0.0,
          0.0), // Position the menu near the member
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.star_border,
                  color: Colors.blue), // Icon for Make Admin
              SizedBox(width: 8),
              Text("Make Admin", style: TextStyle(color: Colors.blue)),
            ],
          ),
          onTap: () {
            // Implement logic for making a member an admin
            print("Make Admin");
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.security,
                  color: Colors.blue), // Icon for Change Permissions
              SizedBox(width: 8),
              Text("Change Permissions", style: TextStyle(color: Colors.blue)),
            ],
          ),
          onTap: () {
            // Implement logic for changing permissions
            print("Change Permissions");
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.delete,
                  color: Colors.red), // Icon for Remove from Group
              SizedBox(width: 8),
              Text("Remove from Group", style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () {
            GlobalGroupsProvider.groupsCubit
                .removeUserFromGroup(groupId: widget.chatId, user: member);
            print("Remove from Group${member.id}");
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  void handleMembersState(GroupsState state) {
    print("anything");
    if (state is UserAddedToGroup) {
      print("aaaaaaaaaaaaaaadd");
      _membersList.add(state.member);
    } else if (state is UserRemovedFromGroup) {
      print("aaaaaaaaaaaaaaaaaaaa:  ${state.user.id}");
      _membersList.removeWhere((member) => member.id == state.user.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child:
                CircularProgressIndicator()) // Show loading indicator if still fetching
        : _errorMessage.isNotEmpty
            ? Center(
                child: Text(
                    _errorMessage)) // Show error message if there was an error
            : _membersList.isEmpty
                ? const Center(
                    child: Text(
                        'No members found.')) // Show if no members are found
                : Expanded(
                    child: BlocProvider<GroupsCubit>.value(
                      value: GlobalGroupsProvider.groupsCubit,
                      child: BlocListener<GroupsCubit, GroupsState>(
                        listener: (context, state) {
                          setState(() {
                            print("received state: $state");
                            handleMembersState(state);
                          });
                        },
                        child: ListView.builder(
                          itemCount: _membersList.length,
                          itemBuilder: (context, index) {
                            final member = _membersList[index];
                            final GlobalKey key = GlobalKey();
                            return GestureDetector(
                              onLongPress: () {
                                if (!member.isAdmin && _isAdmin) {
                                  _showPopupMenu(context, member,
                                      key); // Show menu if not an admin
                                }
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            GroupMemberCard(
                                              key: key,
                                              id: member.id,
                                              userName: member.userName,
                                              profilePic: member.profilePic,
                                              hasStory: member.hasStory,
                                              lastSeen: _formatLastSeen(member
                                                  .lastSeen), // Format lastSeen here
                                            ),
                                            // Add a Divider after each member card
                                          ],
                                        ),
                                      ),
                                      // Show isAdmin at the end of the line
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0,
                                            left: 16.0,
                                            bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              member.isAdmin ? 'Admin' : '',
                                              style: TextStyle(
                                                color:
                                                    Colors.blue, // Make it blue
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey.shade300,
                                    thickness: .25,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
  }
}
