import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/components/voice_message_card.dart';

class ForwardedVoiceMessageCard extends OwnMessage {
  final String blobName;
  final String senderName;

  ForwardedVoiceMessageCard({
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
      isSent: true,
      forwardedFrom: senderName,
      waveformType: WaveformType.fitWidth,
    );
  }
}
