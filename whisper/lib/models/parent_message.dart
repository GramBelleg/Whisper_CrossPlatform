class ParentMessage {
  final int id;
  final int? senderId;
  final String senderName;
  final String? senderProfilePic;
  final String content;
  final String? media;

  ParentMessage({
    required this.id,
    this.senderId,
    required this.senderName,
    this.senderProfilePic,
    required this.content,
    this.media,
  });

  factory ParentMessage.fromJson(Map<String, dynamic> json) {
    return ParentMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderProfilePic: json['senderProfilePic'],
      content: json['content'],
      media: json['media'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfilePic': senderProfilePic,
      'content': content,
      'media': media,
    };
  }

  @override
  String toString() {
    return 'ParentMessage('
        'id: $id, '
        'senderId: $senderId, '
        'senderName: $senderName, '
        'senderProfilePic: $senderProfilePic, '
        'content: $content, '
        'media: $media'
        ')';
  }
}
