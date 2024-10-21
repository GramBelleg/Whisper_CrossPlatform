import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/chat-page.dart';

// Define an enum for message types
enum MessageType {
  text,
  image,
  video,
  soundRecord,
  deletedMessage,
  gif,
  sticker,
}

class ChatCard extends StatelessWidget {
  final String userName;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool isRead;
  final bool isSent;
  final bool isOnline;
  final bool isPinned; // New property for pinned status
  final MessageType messageType;
  final int unreadCount;
  final bool isMuted;

  const ChatCard({
    Key? key,
    required this.userName,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.isRead = false,
    this.isSent = true,
    this.isOnline = false,
    this.isPinned = false, // Default to not pinned
    this.messageType = MessageType.text,
    this.unreadCount = 0,
    this.isMuted = false,
  }) : super(key: key);

  // Define the custom color
  final Color customColor =
      const Color(0xFF4CB9CF); // This is the color you want

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        elevation: 0,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 1),
          leading: _buildAvatar(),
          title: _buildUserName(),
          subtitle: _buildSubtitle(),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTime(),
              const SizedBox(height: 8), // Add more space between time and pin
              if (isPinned)
                _buildPinIcon(), // Conditionally show pin icon below
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  userName: userName,
                  userImage: avatarUrl,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(avatarUrl),
          radius: 25,
        ),
        if (isOnline) _buildOnlineIndicator(),
      ],
    );
  }

  Widget _buildOnlineIndicator() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: customColor, // Apply custom color
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Row(
      mainAxisSize: MainAxisSize.min, // Shrink the row to its minimum width
      children: [
        Text(
          userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Similar to your image
          ),
          overflow: TextOverflow.ellipsis, // Handle overflow gracefully
        ),
        if (isMuted) // Conditionally show the mute icon
          const SizedBox(width: 4), // Small space between the name and icon
        if (isMuted)
          Icon(
            Icons.volume_off,
            size: 16, // Adjust size to fit next to the name
            color: customColor, // Mute icon color as requested
          ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Row(
      children: [
        Expanded(child: _buildLastMessage()),
        const SizedBox(width: 4), // Space between message and status
        if (unreadCount > 0 && messageType != MessageType.deletedMessage)
          _buildUnreadCount(),
      ],
    );
  }

  Widget _buildUnreadCount() {
    return CircleAvatar(
      radius: 10,
      backgroundColor: Colors.red,
      child: Text(
        '$unreadCount',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildTime() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isSent) // Show the status next to the time
          FaIcon(
            FontAwesomeIcons.checkDouble,
            size: 12, // Adjust size to fit better with time text
            color: isRead
                ? customColor // Apply custom color for read status
                : Colors.grey, // Change color based on read status
          ),
        const SizedBox(width: 4), // Space between icon and time
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: const Color.fromRGBO(141, 150, 163, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildPinIcon() {
    return Icon(
      Icons.push_pin,
      size: 16, // Adjust icon size
      color: Colors.yellow, // Color of the pin icon
    );
  }

  Widget _buildLastMessage() {
    String messageText;
    // Generate message text based on the message type
    switch (messageType) {
      case MessageType.image:
        messageText = "📷 Image";
        break;
      case MessageType.video:
        messageText = "📹 Video";
        break;
      case MessageType.soundRecord:
        messageText = "🎤 Voice message";
        break;
      case MessageType.deletedMessage:
        messageText = "🗑️ Message deleted";
        break;
      case MessageType.gif:
        messageText = "🎞️ GIF";
        break;
      case MessageType.sticker:
        messageText = "🎨 Sticker";
        break;
      case MessageType.text:
      default:
        messageText = lastMessage;
        break;
    }
    return Text(
      messageText,
      style: TextStyle(
        color: customColor, // Apply custom color to the message types
      ),
    );
  }

  Widget _buildMuteIcon() {
    return Icon(
      Icons.volume_mute,
      size: 16, // Adjust icon size
      color: Colors.yellow, // Color of the pin icon
    );
  }
}
