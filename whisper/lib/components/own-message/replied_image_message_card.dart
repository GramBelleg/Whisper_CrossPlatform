import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/blob_url_manager.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/pages/full_screen_image_page.dart';

class RepliedImageMessageCard extends OwnMessage {
  final String blobName;
  final String repliedContent;
  final String repliedSenderName;

  RepliedImageMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
    required this.repliedContent,
    required this.repliedSenderName,
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
    return _RepliedImageMessageCardStateful(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      repliedContent: repliedContent,
      repliedSenderName: repliedSenderName,
    );
  }
}

class _RepliedImageMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String repliedContent;
  final String repliedSenderName;

  const _RepliedImageMessageCardStateful({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.repliedContent,
    required this.repliedSenderName,
    Key? key,
  }) : super(key: key);

  @override
  State<_RepliedImageMessageCardStateful> createState() =>
      _RepliedImageMessageCardState();
}

class _RepliedImageMessageCardState
    extends State<_RepliedImageMessageCardStateful> {
  String imageUrl = "";
  bool isDownloading = false;

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
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: widget.isSelected ? selectColor : Colors.transparent,
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
                        borderRadius: BorderRadius.circular(18),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the reply bubble
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xffb39ddb),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.repliedSenderName ?? "Unknown",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.repliedContent,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Display the image message
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
