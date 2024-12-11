import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/services/stickers_service.dart';

class StickerMessageCard extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String forwardedFrom;
  final bool isSent;
  const StickerMessageCard({
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
  State<StickerMessageCard> createState() => _StickerMessageCardState();
}

class _StickerMessageCardState extends State<StickerMessageCard> {
  bool isStickerDownloaded = false;
  bool failedToDownload = false;
  String stickerPath = '';
  Future<void> fetchSticker() async {
    // download the sticker to the device
    print("Downloading sticker ${widget.blobName} to device");
    stickerPath = await StickersService().downloadSticker(widget.blobName);

    if (stickerPath.isNotEmpty) {
      setState(() {
        isStickerDownloaded = true;
      });
    }

    if (stickerPath == "FAILED") {
      setState(() {
        isStickerDownloaded = false;
        failedToDownload = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // download this sticker
    fetchSticker();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        margin: const EdgeInsets.only(right: 15, bottom: 5, top: 5, left: 15),
        width: MediaQuery.of(context).size.width / 1.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              widget.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            widget.forwardedFrom.isNotEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? selectColor
                          : widget.isSent
                              ? primaryColor
                              : firstNeutralColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
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
                    ),
                  )
                : const SizedBox(),
            SizedBox(height: 5),
            isStickerDownloaded
                ? Image.file(
                    File(stickerPath),
                    width: 140,
                  )
                : failedToDownload
                    ? const Text('Failed to download sticker')
                    : const CircularProgressIndicator(),
            const SizedBox(height: 5),
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? selectColor
                    : widget.isSent
                        ? primaryColor
                        : firstNeutralColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.time,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  SizedBox(width: 2),
                  widget.isSent
                      ?
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
                  ) : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
