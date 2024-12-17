import 'package:flutter/material.dart';
import 'package:whisper/models/chat.dart';
import '../models/friend.dart';

class FriendListItem extends StatelessWidget {
  final Chat friend;
  final bool isSelected;
  final VoidCallback onTap;

  const FriendListItem({
    required this.friend,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: friend.avatarUrl == null || friend.avatarUrl!.isEmpty
            ? null
            : (friend.avatarUrl!.startsWith('assets/')
                ? AssetImage(friend.avatarUrl!)
                : NetworkImage(friend.avatarUrl!) as ImageProvider),
        child: friend.avatarUrl == null || friend.avatarUrl!.isEmpty
            ? Icon(Icons.person)
            : null,
      ),
      title: Text(
        friend.userName,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: isSelected ? const Color(0xff8d6aee) : Colors.white,
      ),
      onTap: onTap,
    );
  }
}
