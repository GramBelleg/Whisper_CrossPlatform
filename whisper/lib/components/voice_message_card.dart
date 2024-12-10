import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/audio_player_widget.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VoiceMessageCard extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String forwardedFrom;
  final bool isSent;
  final WaveformType waveformType;

  const VoiceMessageCard({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.isSent,
    this.forwardedFrom = "",
    required this.waveformType,
    super.key,
  });

  @override
  VoiceMessageCardState createState() => VoiceMessageCardState();
}

class VoiceMessageCardState extends State<VoiceMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(right: 15, bottom: 5, top: 5, left: 15),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? selectColor
              : widget.isSent
                  ? primaryColor
                  : firstNeutralColor,
          borderRadius: widget.isSent
              ? BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
        ),
        width: MediaQuery.of(context).size.width / 1.3,
        // height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            widget.forwardedFrom.isNotEmpty
                ? Row(
                    children: [
                      Icon(FontAwesomeIcons.forward,
                          color: Colors.white70, size: 12),
                      Text(
                        ' Forwarded from: ${widget.forwardedFrom}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  )
                : const SizedBox(),
            AudioPlayerWidget(
              blobName: widget.blobName,
              isSent: widget.isSent,
              waveformType: widget.waveformType,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.time,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                SizedBox(width: 2),
                Icon(
                  widget.status == MessageStatus.seen
                      ? FontAwesomeIcons.checkDouble
                      : widget.status == MessageStatus.received
                          ? FontAwesomeIcons.checkDouble
                          : FontAwesomeIcons.check,
                  color: widget.status == MessageStatus.seen
                      ? Colors.blue
                      : Colors.white,
                  size: 12,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
