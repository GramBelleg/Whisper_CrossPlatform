import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/group_user_permissions_cubit.dart';

class GroupUserPermissionsPage extends StatefulWidget {
  final int chatId;
  final int userId;

  const GroupUserPermissionsPage({
    super.key,
    required this.chatId,
    required this.userId,
  });

  @override
  State<GroupUserPermissionsPage> createState() =>
      _GroupUserPermissionsPageState();
}

class _GroupUserPermissionsPageState extends State<GroupUserPermissionsPage> {

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
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
          "User ${widget.userId} Permissions in group ${widget.chatId}",
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: firstNeutralColor,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: BlocBuilder<GroupUserPermissionsCubit, Map<String, bool>>(
        builder: (context, permissionsState) {
          return ListView(
            children: [
              ListTile(
                title: Text(
                  "Can post",
                  style: TextStyle(color: secondNeutralColor),
                ),
                trailing: Switch(
                  value: permissionsState['canPost'] ?? false,
                  onChanged: (value) {
                    context.read<GroupUserPermissionsCubit>().updatePermissions(
                          widget.chatId,
                          widget.userId,
                          'canPost',
                          value,
                        );
                  },
                ),
              ),
              ListTile(
                title: Text(
                  "Can edit messages",
                  style: TextStyle(color: secondNeutralColor),
                ),
                trailing: Switch(
                  value: permissionsState['canEdit'] ?? false,
                  onChanged: (value) {
                    context.read<GroupUserPermissionsCubit>().updatePermissions(
                          widget.chatId,
                          widget.userId,
                          'canEdit',
                          value,
                        );
                  },
                ),
              ),
              ListTile(
                title: Text(
                  "Can delete messages",
                  style: TextStyle(color: secondNeutralColor),
                ),
                trailing: Switch(
                  value: permissionsState['canDelete'] ?? false,
                  onChanged: (value) {
                    context.read<GroupUserPermissionsCubit>().updatePermissions(
                          widget.chatId,
                          widget.userId,
                          'canDelete',
                          value,
                        );
                  },
                ),
              ),
              ListTile(
                title: Text(
                  "Can download media",
                  style: TextStyle(color: secondNeutralColor),
                ),
                trailing: Switch(
                  value: permissionsState['canDownload'] ?? false,
                  onChanged: (value) {
                    context.read<GroupUserPermissionsCubit>().updatePermissions(
                          widget.chatId,
                          widget.userId,
                          'canDownload',
                          value,
                        );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
