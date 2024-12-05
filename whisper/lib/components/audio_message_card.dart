import 'package:flutter/material.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/components/voice_message_card.dart';

class AudioMessageCard extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String forwardedFrom;
  final bool isSent;

  const AudioMessageCard({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.isSent,
    this.forwardedFrom = "",
    super.key,
  });

  @override
  State<AudioMessageCard> createState() => _AudioMessageCardState();
}

class _AudioMessageCardState extends State<AudioMessageCard> {
  @override
  Widget build(BuildContext context) {

    // TODO: add some other UI here

    return VoiceMessageCard(
      blobName: widget.blobName,
      message: widget.message,
      time: widget.time,
      isSelected: widget.isSelected,
      status: widget.status,
      isSent: widget.isSent,
      forwardedFrom: widget.forwardedFrom,
    );
  }
}
