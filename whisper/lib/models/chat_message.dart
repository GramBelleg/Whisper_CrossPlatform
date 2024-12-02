import 'package:whisper/models/forwarded_from.dart';
import 'package:whisper/models/parent_message.dart';
import 'package:whisper/models/sender.dart';

class ChatMessage {
  int? id;
  final int chatId;
  final Sender? sender;
  final List<dynamic>? mentions;
  final String content;
  final String? media;
  DateTime? time;
  DateTime? sentAt;
  final bool? read;
  final bool? delivered;
  final bool? forwarded;
  final bool? pinned;
  final bool? edited;
  final bool? selfDestruct;
  final bool? isAnnouncement;
  final bool? isSecret;
  final int? expiresAfter;
  final String type;
  final ParentMessage? parentMessage;
  final ForwardedFrom? forwardedFrom;
  final String? extension;

  ChatMessage({
    this.id,
    required this.chatId,
    this.sender,
    this.mentions,
    required this.content,
    this.media,
    this.time,
    required this.sentAt,
    this.read,
    this.delivered,
    this.forwarded,
    this.pinned,
    this.edited,
    this.selfDestruct,
    this.isAnnouncement,
    this.isSecret,
    this.expiresAfter,
    required this.type,
    this.parentMessage,
    this.forwardedFrom,
    this.extension,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chatId'],
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      mentions: json['mentions'] != null
          ? List<dynamic>.from(json['mentions'])
          : null,
      content: json['content'],
      media: json['media'],
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      read: json['read'],
      delivered: json['delivered'],
      forwarded: json['forwarded'],
      pinned: json['pinned'],
      edited: json['edited'],
      selfDestruct: json['selfDestruct'],
      isAnnouncement: json['isAnnouncement'],
      isSecret: json['isSecret'],
      expiresAfter: json['expiresAfter'],
      type: json['type'],
      parentMessage: json['parentMessage'] != null
          ? ParentMessage.fromJson(json['parentMessage'])
          : null,
      forwardedFrom: json['forwardedFrom'] != null
          ? ForwardedFrom.fromJson(json['forwardedFrom'])
          : null,
      extension: json['extension'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'sender': sender?.toJson(),
      'mentions': mentions,
      'content': content,
      'media': media,
      'time': time?.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'read': read,
      'delivered': delivered,
      'forwarded': forwarded,
      'pinned': pinned,
      'edited': edited,
      'selfDestruct': selfDestruct,
      'isAnnouncement': isAnnouncement,
      'isSecret': isSecret,
      'expiresAfter': expiresAfter,
      'type': type,
      'parentMessage': parentMessage?.toJson(),
      'forwardedFrom': forwardedFrom?.toJson(),
      'extension': extension
    };
  }

  @override
  String toString() {
    return 'ChatMessage('
        'id: $id, '
        'chatId: $chatId, '
        'sender: $sender, '
        'mentions: $mentions, '
        'content: $content, '
        'media: $media, '
        'time: $time, '
        'sentAt: $sentAt, '
        'read: $read, '
        'delivered: $delivered, '
        'forwarded: $forwarded, '
        'pinned: $pinned, '
        'edited: $edited, '
        'selfDestruct: $selfDestruct, '
        'isAnnouncement: $isAnnouncement, '
        'isSecret: $isSecret, '
        'expiresAfter: $expiresAfter, '
        'type: $type, '
        'parentMessage: $parentMessage, '
        'forwardedFrom: $forwardedFrom'
        ')';
  }
}
