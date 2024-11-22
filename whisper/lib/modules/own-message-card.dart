import 'package:flutter/material.dart';
import 'package:whisper/models/chat-messages.dart';
import 'package:whisper/models/parent-message.dart';
import 'package:whisper/modules/forwarded-message-card.dart';
import 'package:whisper/modules/normal-message-card.dart';
import 'package:whisper/modules/replied-message-card.dart';

enum MessageStatus {
  sent,
  received,
  seen,
}

class OwnMessageCard extends StatelessWidget {
  final String message;
  final DateTime time;
  final MessageStatus status;
  final bool isSelected;
  final bool isForwarded; // New property to check if the message is forwarded
  final ParentMessage? repliedMessage;
  final String messageSenderName;
  OwnMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.isSelected,
    this.status = MessageStatus.sent,
    this.repliedMessage,
    this.isForwarded = false, // Default is false
    this.messageSenderName = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isForwarded) {
      return ForwardedMessageCard(
        message: message,
        time: time,
        status: status,
        isSelected: isSelected,
        messageSenderName: messageSenderName,
      );
    } else if (repliedMessage != null) {
      return RepliedMessageCard(
        message: message,
        time: time,
        status: status,
        isSelected: isSelected,
        repliedMessage: repliedMessage!,
      );
    } else {
      return NormalMessageCard(
        message: message,
        time: time,
        status: status,
        isSelected: isSelected,
      );
    }
  }
}
