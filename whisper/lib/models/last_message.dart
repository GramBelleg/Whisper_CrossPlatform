import 'package:intl/intl.dart';

class LastMessage {
  final int id;
  final int senderId;
  final String senderName;
  final bool drafted;
  final String content;
  final String time;
  final bool read;
  final bool delivered;
  final String media;
  final String messageType;

  LastMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.drafted,
    required this.content,
    required this.time,
    required this.read,
    required this.delivered,
    required this.media,
    required this.messageType,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'] ?? 0,
      senderId: json['sender']?['id'] ?? 0,
      senderName: json['sender']?['userName'] ?? 'Unknown',
      drafted: json['drafted'] ?? false,
      content: json['content'] ?? '',
      time: json['time'] ?? '',
      read: json['read'] ?? false,
      delivered: json['delivered'] ?? false,
      media: json['media'] ?? '',
      messageType: json['type'] ?? 'TEXT', // Default type in case of null
    );
  }

  // Initialization function for when `lastMessage` is null
  factory LastMessage.initLastMessage() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    print(formattedDate); // Example output: 2024-12-15 14:30:45
    return LastMessage(
      id: 0,
      senderId: 0,
      senderName: 'Unknown',
      drafted: false,
      content: 'No messages',
      time: formattedDate,
      read: false,
      delivered: false,
      media: '',
      messageType: "TEXT", // Default message type
    );
  }

  // Convert LastMessage object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': {
        'id': senderId,
        'userName': senderName,
      },
      'drafted': drafted,
      'content': content,
      'time': time,
      'read': read,
      'delivered': delivered,
      'media': media,
      'type': messageType,
    };
  }
}
