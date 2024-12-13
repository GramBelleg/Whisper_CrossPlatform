import 'package:flutter/material.dart';
import 'package:whisper/components/audio_message_card.dart';
import 'package:whisper/components/receive-message/received_message.dart';

class ReceivedForwardedAudioMessageCard extends ReceivedMessage {
  final String blobName;

  ReceivedForwardedAudioMessageCard({
    required this.blobName,
    required super.message,
    required super.time,
    required super.isSelected,
    required super.status,
    required super.senderName,
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
      isSent: false,
      forwardedFrom: senderName,
    );
  }
}
