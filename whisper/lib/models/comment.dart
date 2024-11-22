import 'package:whisper/models/chat-messages.dart';
import 'package:whisper/models/sender.dart';

class Comment {
  final int id;
  final Sender sender;
  final String content;
  final DateTime time;

  Comment({
    required this.id,
    required this.sender,
    required this.content,
    required this.time,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      sender: Sender.fromJson(json['sender']),
      content: json['content'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'content': content,
      'time': time.toIso8601String(),
    };
  }
}
