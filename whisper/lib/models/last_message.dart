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
  final MessageType messageType;

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
      senderId: json['sender']?['id'] ?? 0, // Accessing 'sender.id'
      senderName: json['sender']?['userName'] ??
          'Unknown', // Accessing 'sender.userName'
      drafted: json['drafted'] ?? false,
      content: json['content'] ?? '',
      time: json['time'] ?? '', // 'time' is directly available in lastMessage
      read: json['read'] ?? false,
      delivered: json['delivered'] ?? false,
      media: json['media'] ?? '',
      messageType: _getMessageType(
          json['type']), // Adjusted to 'type' key for message type
    );
  }

  // Change this to a static method
  static MessageType _getMessageType(String? type) {
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
}
