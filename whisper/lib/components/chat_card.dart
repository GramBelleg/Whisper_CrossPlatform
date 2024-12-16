import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/models/chat.dart';
import 'package:whisper/pages/chat_page.dart';
import 'package:whisper/services/shared_preferences.dart';

enum MessageType {
  TEXT,
  VM,
  AUDIO,
  IMAGE,
  FILE,
  DELETED,
  STICKER,
  GIF,
  VIDEO,
}

class ChatCard extends StatelessWidget {
  final Chat chat;

  const ChatCard({
    super.key,
    required this.chat,
  });

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
            ],
          ),
          onTap: () async {
            String? token = await getToken();
            int? senderId = await getId();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  userName: chat.userName,
                  userImage: chat.avatarUrl,
                  ChatID: chat.chatId,
                  token: token,
                  senderId: senderId,
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
          backgroundImage: NetworkImage(chat.avatarUrl),
          radius: 25,
        ),
        if (chat.isOnline) _buildOnlineIndicator(),
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
          color: highlightColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          chat.userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (chat.isMuted) const SizedBox(width: 4),
        if (chat.isMuted)
          Icon(
            Icons.volume_off,
            size: 16,
            color: highlightColor,
          ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Row(
      children: [
        Expanded(child: _buildLastMessage()),
        const SizedBox(width: 4),
        if (chat.unreadMessageCount > 0 &&
            _getMessageType(chat.lastMessage.messageType) !=
                MessageType.DELETED)
          _buildUnreadCount(),
      ],
    );
  }

  Widget _buildUnreadCount() {
    return CircleAvatar(
      radius: 10,
      backgroundColor: Colors.red,
      child: Text(
        '${chat.unreadMessageCount}',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildTime() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!chat.isSent)
          FaIcon(
            FontAwesomeIcons.checkDouble,
            size: 12,
            color: chat.isRead ? highlightColor : Colors.grey,
          ),
        const SizedBox(width: 4),
        Text(
          formatMessageTime(chat.time),
          style: TextStyle(
            fontSize: 12,
            color: const Color.fromRGBO(141, 150, 163, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildLastMessage() {
    String messageText;
    switch (_getMessageType(chat.lastMessage.messageType)) {
      case MessageType.IMAGE:
        messageText = "📷 Image";
        break;
      case MessageType.VM:
        messageText = "🎤 Voice message";
        break;
      case MessageType.AUDIO:
        messageText = "🎧 Audio";
        break;
      case MessageType.FILE:
        messageText = "📁 File";
        break;
      case MessageType.DELETED:
        messageText = "🗑️ Message deleted";
        break;
      case MessageType.STICKER:
        messageText = "🎨 Sticker";
        break;
      case MessageType.GIF:
        messageText = "🎞️ GIF";
        break;
      case MessageType.VIDEO:
        messageText = "📹 Video";
        break;
      case MessageType.TEXT:
      default:
        messageText = chat.lastMessage.content;
        break;
    }

    return Text(
      chat.type == "GROUP"
          ? "${chat.lastMessage.senderName == chat.userName ? "Me" : chat.lastMessage.senderName == "Unknown" ? '' : chat.lastMessage.senderName}: $messageText"
          : messageText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Color.fromRGBO(141, 150, 163, 1)),
    );
  }

  MessageType _getMessageType(String? type) {
    switch (type?.toUpperCase()) {
      case 'TEXT':
        return MessageType.TEXT;
      case 'IMAGE':
        return MessageType.IMAGE;
      case 'VIDEO':
        return MessageType.VIDEO;
      case 'AUDIO':
        return MessageType.AUDIO;
      case 'GIF':
        return MessageType.GIF;
      case 'STICKER':
        return MessageType.STICKER;
      case 'FILE':
        return MessageType.FILE;
      case 'DELETED':
        return MessageType.DELETED;
      case 'VM':
        return MessageType.VM;
      default:
        return MessageType.TEXT;
    }
  }

  String formatMessageTime(String? isoTime) {
    if (isoTime == null) return '';
    try {
      DateTime messageTime = DateTime.parse(isoTime).toLocal();
      return DateFormat('hh:mm a').format(messageTime);
    } catch (e) {
      return '';
    }
  }
}
