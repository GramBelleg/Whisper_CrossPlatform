import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:whisper/modules/receive-message/received-message.dart';
import 'package:whisper/pages/full-screen-image-page.dart';
import 'package:whisper/services/read-file.dart';

class ImageReceivedMessageCard extends ReceivedMessage {
  final String blobName;

  ImageReceivedMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
    required MessageStatus status,
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
    return _ImageReceivedMessageCardStateful(
      blobName: blobName,
      caption: message,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
    );
  }
}

class _ImageReceivedMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String caption;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;

  const _ImageReceivedMessageCardStateful({
    required this.blobName,
    required this.caption,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  State<_ImageReceivedMessageCardStateful> createState() =>
      _ImageReceivedMessageCardState();
}

class _ImageReceivedMessageCardState
    extends State<_ImageReceivedMessageCardStateful> {
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _generateImageUrl(widget.blobName);
  }

  Future<void> _generateImageUrl(String blobName) async {
    try {
      String url = await generatePresignedUrl(blobName);
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      print('Error generating image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: imageUrl.isEmpty
          ? const CircularProgressIndicator() // Show loading until image URL is fetched
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: widget.isSelected ? selectColor : Colors.transparent,
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Card(
                      color: const Color(0xff0A122F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              widget.caption,
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
                                      fontSize: 12, color: Colors.white70),
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
