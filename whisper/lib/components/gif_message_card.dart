import 'package:flutter/material.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GifMessageCard extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String forwardedFrom;
  final bool isSent;
  const GifMessageCard({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    this.forwardedFrom = "",
    required this.isSent,
    super.key,
  });

  @override
  State<GifMessageCard> createState() => _GifMessageCardState();
}

class _GifMessageCardState extends State<GifMessageCard> {
  String gifUrl = '';

  @override
  void initState() {
    super.initState();
    gifUrl = widget.blobName;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.forwardedFrom.isNotEmpty
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                SizedBox(height: 5),
            Image.network(
              gifUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Row(
                  children: [
                    const CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                    'Loading Your Gif...',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.time,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                SizedBox(width: 2),
                widget.isSent ?
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
                ) : const SizedBox(),
                SizedBox(width: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
