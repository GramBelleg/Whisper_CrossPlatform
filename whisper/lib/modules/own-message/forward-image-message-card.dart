import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/blob-url-manager.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/file-message-cubit.dart';
import 'package:whisper/cubit/file-message-states.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/pages/full-screen-image-page.dart';

class ForwardedImageMessageCard extends OwnMessage {
  final String blobName;
  final String forwardedSenderName;

  ForwardedImageMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
    required MessageStatus status,
    required this.forwardedSenderName,
    Key? key,
  }) : super(
          message: message,
          time: time,
          isSelected: isSelected,
          status: status,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return _ForwardedImageMessageCardStateful(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      forwardedSenderName: forwardedSenderName,
    );
  }
}

class _ForwardedImageMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String forwardedSenderName;

  const _ForwardedImageMessageCardStateful({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.forwardedSenderName,
    Key? key,
  }) : super(key: key);

  @override
  State<_ForwardedImageMessageCardStateful> createState() =>
      _ForwardedImageMessageCardState();
}

class _ForwardedImageMessageCardState
    extends State<_ForwardedImageMessageCardStateful> {
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    if (BlobUrlManager.isExist(widget.blobName)) {
      imageUrl = BlobUrlManager.getBlobUrl(widget.blobName)!;
    } else {
      _generateImageUrl(widget.blobName);
    }
  }

  Future<void> _generateImageUrl(String blobName) async {
    try {
      String url = await generatePresignedUrl(blobName);
      setState(() {
        imageUrl = url;
        BlobUrlManager.addBlobUrl(widget.blobName, url);
      });
    } catch (e) {
      print('Error generating image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: imageUrl.isEmpty
          ? const CircularProgressIndicator() // Show loading until image URL is fetched
          : Container(
              color: widget.isSelected ? selectColor : Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Card(
                      color: const Color(0xFF8D6AEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display 'Forwarded from' text
                            Text(
                              'Forwarded from:',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              widget.forwardedSenderName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Display the image
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImagePage(
                                      imageUrl: imageUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.message,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Time and message status
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  widget.status == MessageStatus.seen
                                      ? FontAwesomeIcons.checkDouble
                                      : widget.status == MessageStatus.received
                                          ? FontAwesomeIcons.check
                                          : FontAwesomeIcons.clock,
                                  color: widget.status == MessageStatus.seen
                                      ? Colors.blue
                                      : Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
