import 'package:flutter/material.dart';
import 'package:whisper/components/audio_message_card.dart';
import 'package:whisper/components/own-message/own_message.dart';

class ForwardedAudioMessageCard extends OwnMessage {
  final String blobName;
  final String senderName;

  ForwardedAudioMessageCard({
    required this.blobName,
    required this.senderName,
    required super.message,
    required super.time,
    required super.isSelected,
    required super.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AudioMessageCard(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      isSent: true,
      forwardedFrom: senderName,
    );
  }
}
