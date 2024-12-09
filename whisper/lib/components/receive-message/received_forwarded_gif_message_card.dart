import 'package:flutter/material.dart';
import 'package:whisper/components/gif_message_card.dart';
import 'package:whisper/components/receive-message/received_message.dart';

class ReceivedForwardedGifMessageCard extends ReceivedMessage {
  final String blobName;
  final String senderName;

  ReceivedForwardedGifMessageCard({
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
    return GifMessageCard(
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
