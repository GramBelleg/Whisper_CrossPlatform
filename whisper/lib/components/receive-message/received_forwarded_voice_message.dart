import 'package:flutter/material.dart';
import 'package:whisper/components/receive-message/received_message.dart';
import 'package:whisper/components/voice_message_card.dart';

class ReceivedForwardedVoiceMessage extends ReceivedMessage {
  final String blobName;
  final String senderName;

  ReceivedForwardedVoiceMessage({
    required this.blobName,
    required super.message,
    required super.time,
    required super.isSelected,
    required super.status,
    required this.senderName,
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
      forwardedFrom: senderName,
    );
  }
}

