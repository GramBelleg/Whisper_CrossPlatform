import 'package:whisper/components/helpers.dart';
import 'package:whisper/models/last_message.dart';

class Chat {
  final int chatid;
  final int othersId;
  final String userName;
  final String avatarUrl;
  final bool hasStory;
  final bool isMuted;
  final bool isAdmin;
  final String status;
  final String lastSeen;
  final bool isOnline;
  final String time;
  final String type;
  final LastMessage lastMessage;
  final bool isRead;
  final bool isSent;
  final int unreadMessageCount;

  Chat({
    required this.chatid,
    required this.othersId,
    required this.userName,
    required this.avatarUrl,
    required this.hasStory,
    required this.isMuted,
    required this.isAdmin,
    required this.status,
    required this.lastSeen,
    required this.isOnline,
    required this.time,
    required this.type,
    required this.lastMessage,
    required this.isRead,
    required this.isSent,
    required this.unreadMessageCount,
  });

  factory Chat.fromJson(
      Map<String, dynamic> json, bool isOnline, String formattedTime) {
    return Chat(
      chatid: json['chatid'] ?? 0,
      othersId: json['othersId'] ?? 0,
      userName: json['userName'] ?? 'Unknown User',
      avatarUrl: json['avatarUrl'] ??
          "https://ui-avatars.com/api/?background=0a122f&size=100&color=fff&name=${formatName(json['userName'] ?? 'Unknown User')}",
      hasStory: json['hasStory'] ?? false,
      isMuted: json['isMuted'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      status: json['status'] ?? '',
      lastSeen: json['lastSeen'] ?? '',
      isOnline: isOnline,
      time: formattedTime,
      type: json['type'] ?? '',
      lastMessage: LastMessage.fromJson(json['lastMessage']),
      isRead: json['unreadMessageCount'] == 0,
      isSent: json['lastMessage']?['senderId'] == json['othersId'],
      unreadMessageCount: json['unreadMessageCount'] ?? 0,
    );
  }
}
