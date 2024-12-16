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

  factory Chat.fromJson(
      Map<String, dynamic> json, bool isOnline, LastMessage lastMessage) {
    return Chat(
      chatId: json['id'] ?? 0,
      othersId: json['othersId'] ?? 0,
      userName: json['name'] ?? 'Unknown User',
      avatarUrl: json['picture'] ?? '',
      hasStory: json['hasStory'] ?? false,
      isMuted: json['isMuted'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      status: json['status'] ?? '',
      lastSeen: json['lastSeen'] ?? '',
      isOnline: isOnline,
      time: lastMessage.time, // Handle if lastMessage is null
      type: json['type'] ?? '',
      lastMessage: lastMessage,
      isRead: json['unreadMessageCount'] == 0,
      isSent: json['lastMessage']?['sender']?['id'] == json['othersId'],
      unreadMessageCount: json['unreadMessageCount'] ?? 0,
    );
  }

  // CopyWith method
  Chat copyWith({
    int? chatId,
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
      chatId: chatId ?? this.chatId,
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

  // Convert Chat object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': chatId,
      'othersId': othersId,
      'name': userName,
      'picture': avatarUrl,
      'hasStory': hasStory,
      'isMuted': isMuted,
      'isAdmin': isAdmin,
      'status': status,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
      'time': time,
      'type': type,
      'lastMessage':
          lastMessage.toJson(), // assuming LastMessage has a toJson method
      'isRead': isRead,
      'isSent': isSent,
      'unreadMessageCount': unreadMessageCount,
    };
  }
}
