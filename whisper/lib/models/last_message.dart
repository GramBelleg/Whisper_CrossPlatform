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
      senderId: json['senderId'] ?? 0,
      senderName: json['senderName'] ?? 'Unknown',
      drafted: json['drafted'] ?? false,
      content: json['content'] ?? '',
      time: json['time'] ?? '',
      read: json['read'] ?? false,
      delivered: json['delivered'] ?? false,
      media: json['media'] ?? '',
      messageType: _getMessageType(json['messageType']),
    );
  }

  static String _getMessageType(String type) {
    switch (type) {
      case 'text':
        return 'Text Message';
      case 'image':
        return 'Image Message';
      case 'video':
        return 'Video Message';
      // Add more cases for other types
      default:
        return 'Unknown';
    }
  }
}
