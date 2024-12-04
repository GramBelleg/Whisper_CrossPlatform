import 'package:flutter/material.dart';
import 'package:whisper/components/receive-message/received_message.dart';
import 'package:whisper/components/voice_message_card.dart';

class ReceivedVoiceMessageCard extends ReceivedMessage {
  final String blobName;

  ReceivedVoiceMessageCard({
    required this.blobName,
    required super.message,
    required super.time,
    required super.isSelected,
    required super.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VoiceMessageCard(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      isSent: false,
    );
  }
}
