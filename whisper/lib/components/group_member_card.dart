import 'package:flutter/material.dart';

class GroupMemberCard extends StatelessWidget {
  final int id;
  final String userName;
  final String? profilePic;
  final bool isAdmin;
  final bool hasStory;
  final String lastSeen;

  const GroupMemberCard({
    super.key,
    required this.id,
    required this.userName,
    required this.profilePic,
    this.isAdmin = false,
    this.hasStory = false,
    required this.lastSeen,
  });

  // Define custom color
  final Color customColor = const Color(0xFF4CB9CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: ListTile(
          leading: _buildAvatar(),
          title: _buildUserName(),
          subtitle: _buildLastSeen(),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: profilePic != null
              ? NetworkImage(
                  profilePic!) // Load profile picture from URL if available
              : null, // If profilePic is null, don't set backgroundImage
          backgroundColor: Colors.grey.shade300,
          child: profilePic == null
              ? Icon(
                  Icons.person,
                  size: 25,
                  color: Colors.grey.shade600,
                ) // Show an icon if profilePic is null
              : null, // No icon if profilePic is not null
        ),
        if (hasStory) // Add border or overlay for story
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (isAdmin) // Display admin badge
          const SizedBox(width: 4),
        if (isAdmin)
          Icon(
            Icons.star,
            size: 16,
            color: Colors.yellow,
          ),
      ],
    );
  }

  Widget _buildLastSeen() {
    return Text(
      "Last seen: $lastSeen",
      style: TextStyle(
        fontSize: 12,
        color: const Color.fromRGBO(141, 150, 163, 1),
      ),
    );
  }
}
