import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/components/group_member_card.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/group_user_permissions_cubit.dart';

class GroupUserPermissionsPage extends StatefulWidget {
  final int chatId;
  final int userId;
  final String userName;
  final String? profilePic;
  final String lastSeen;

  const GroupUserPermissionsPage({
    super.key,
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.profilePic,
    required this.lastSeen,
  });

  @override
  State<GroupUserPermissionsPage> createState() =>
      _GroupUserPermissionsPageState();
}

class _GroupUserPermissionsPageState extends State<GroupUserPermissionsPage> {
  @override
  void initState() {
    super.initState();
    // Load user permissions on page initialization
    context
        .read<GroupUserPermissionsCubit>()
        .loadUserPermissions(widget.chatId, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      appBar: AppBar(
        title: Text(
          "Change User Permissions",
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: firstNeutralColor,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: BlocBuilder<GroupUserPermissionsCubit, GroupUserPermissionsState>(
        builder: (context, state) {
          if (state is PermissionsLoading) {
            // Show a loading indicator while data is being fetched
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else if (state is PermissionsError) {
            // Show an error message if something went wrong
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 10),
                  Text(
                    state.errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Retry loading permissions
                      context
                          .read<GroupUserPermissionsCubit>()
                          .loadUserPermissions(widget.chatId, widget.userId);
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is PermissionsLoaded) {
            // Show the permissions as a list of switches
            final permissions = state.permissions;
            return ListView(
              children: [
                GroupMemberCard(
                  id: widget.userId,
                  userName: widget.userName,
                  profilePic: widget.profilePic,
                  lastSeen: widget.lastSeen,
                ),
                _buildPermissionTile(
                  context,
                  "Can post",
                  'canPost',
                  permissions['canPost'] ?? false,
                ),
                _buildPermissionTile(
                  context,
                  "Can edit messages",
                  'canEdit',
                  permissions['canEdit'] ?? false,
                ),
                _buildPermissionTile(
                  context,
                  "Can delete messages",
                  'canDelete',
                  permissions['canDelete'] ?? false,
                ),
                _buildPermissionTile(
                  context,
                  "Can download media",
                  'canDownload',
                  permissions['canDownload'] ?? false,
                ),
              ],
            );
          } else {
            // Default fallback (unlikely to be reached)
            return Center(
              child: Text(
                "Unknown state",
                style: TextStyle(color: secondNeutralColor),
              ),
            );
          }
        },
      ),
    );
  }

  // Helper method to build a permission tile with a switch
  Widget _buildPermissionTile(BuildContext context, String title,
      String permissionKey, bool currentValue) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: secondNeutralColor),
      ),
      trailing: Switch(
        value: currentValue,
        onChanged: (value) {
          context.read<GroupUserPermissionsCubit>().updatePermission(
                widget.chatId,
                widget.userId,
                permissionKey,
                value,
              );
        },
      ),
    );
  }
}
