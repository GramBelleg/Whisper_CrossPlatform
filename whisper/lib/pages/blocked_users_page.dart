import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/blocked_users_cubit.dart';
import '../constants/colors.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {

  @override
  void initState() {
    super.initState();
    // Fetch blocked users when the page is initialized
    context.read<BlockedUsersCubit>().fetchBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: firstNeutralColor,
        appBar: AppBar(
          title: Text(
            "Blocked Users",
            style: TextStyle(color: primaryColor),
          ),
          backgroundColor: firstNeutralColor,
          iconTheme: IconThemeData(color: primaryColor),
        ),
        body: BlocBuilder<BlockedUsersCubit, List<Map<String, dynamic>>>(
          builder: (context, blockedUsers) {
            if (blockedUsers.isEmpty) {
              return Center(
                child: Text(
                  "You have no blocked users",
                  style: TextStyle(
                    fontSize: 18,
                    color: secondNeutralColor,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['profilePic'] != null
                        ? NetworkImage(user['profilePic'])
                        : null,
                    child: user['profilePic'] == null
                        ? Icon(Icons.person, color: secondNeutralColor)
                        : null,
                  ),
                  title: Text(
                    user['userName'],
                    style: TextStyle(color: secondNeutralColor),
                  ),
                  trailing: IconButton(
                    key: Key('UnblockButton_${index.toString()}'),
                    icon: Icon(Icons.close, color: secondNeutralColor),
                    onPressed: () =>
                        context.read<BlockedUsersCubit>().unblockUser(index),
                  ),
                );
              },
            );
          },
        ));
  }
}
