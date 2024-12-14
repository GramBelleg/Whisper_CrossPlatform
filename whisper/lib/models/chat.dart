import 'package:whisper/components/helpers.dart';
import 'package:whisper/models/last_message.dart';

class Chat {
  final int chatId;
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
    required this.chatId,
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

  factory Chat.fromJson(Map<String, dynamic> json, bool isOnline) {
    return Chat(
      chatId: json['id'] ?? 0, // 'id' instead of 'chatid'
      othersId: json['othersId'] ?? 0,
      userName: json['name'] ?? 'Unknown User', // 'name' instead of 'userName'
      avatarUrl: json['picture'] ??
          "https://ui-avatars.com/api/?background=0a122f&size=100&color=fff&name=${formatName(json['name'] ?? 'Unknown User')}", // 'picture' instead of 'avatarUrl'
      hasStory: json['hasStory'] ?? false,
      isMuted: json['isMuted'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      status: json['status'] ?? '',
      lastSeen: json['lastSeen'] ?? '',
      isOnline: isOnline,
      time: json['lastMessage'][
          'time'], // You may want to use this or parse the 'lastMessage.time' here
      type: json['type'] ?? '',
      lastMessage: LastMessage.fromJson(json['lastMessage']),
      isRead: json['unreadMessageCount'] == 0,
      isSent: json['lastMessage']?['sender']?['id'] ==
          json['othersId'], // Adjusting to access sender's id
      unreadMessageCount: json['unreadMessageCount'] ?? 0,
    );
  }

  // CopyWith method
  Chat copyWith({
    int? chatid,
    int? othersId,
    String? userName,
    String? avatarUrl,
    bool? hasStory,
    bool? isMuted,
    bool? isAdmin,
    String? status,
    String? lastSeen,
    bool? isOnline,
    String? time,
    String? type,
    LastMessage? lastMessage,
    bool? isRead,
    bool? isSent,
    int? unreadMessageCount,
  }) {
    return Chat(
      chatId: chatid ?? this.chatId,
      othersId: othersId ?? this.othersId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hasStory: hasStory ?? this.hasStory,
      isMuted: isMuted ?? this.isMuted,
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      time: time ?? this.time,
      type: type ?? this.type,
      lastMessage: lastMessage ?? this.lastMessage,
      isRead: isRead ?? this.isRead,
      isSent: isSent ?? this.isSent,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
    );
  }
}
