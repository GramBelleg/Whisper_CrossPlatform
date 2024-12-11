import 'package:flutter/material.dart';
import 'package:whisper/components/receive-message/received_message.dart';
import 'package:whisper/components/sticker_message_card.dart';

class ReceivedStickerMessageCard extends ReceivedMessage {
  final String blobName;

  ReceivedStickerMessageCard({
    required this.blobName,
    required super.message,
    required super.time,
    required super.isSelected,
    required super.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StickerMessageCard(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      isSent: false,
    );
  }
}
