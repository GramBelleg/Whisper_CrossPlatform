import 'package:flutter/material.dart';
import '../models/friend.dart';

class FriendListItem extends StatelessWidget {
  final Friend friend;
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
        backgroundImage: friend.icon == null || friend.icon!.isEmpty
            ? null 
            : (friend.icon!.startsWith('assets/')
                ? AssetImage(friend.icon!)
                : NetworkImage(friend.icon!) as ImageProvider),
        child: friend.icon == null || friend.icon!.isEmpty
            ? Icon(Icons.person) 
            : null, 
      ),
      title: Text(
        friend.name,
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
