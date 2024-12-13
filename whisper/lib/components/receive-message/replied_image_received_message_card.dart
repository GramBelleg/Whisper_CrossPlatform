import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/blob_url_manager.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/components/receive-message/received_message.dart';
import 'package:whisper/pages/full_screen_image_page.dart';
import 'package:whisper/services/read_file.dart';

class RepliedImageReceivedMessageCard extends ReceivedMessage {
  final String blobName;
  final String repliedContent;
  final String repliedSenderName;

  RepliedImageReceivedMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
    required this.repliedContent,
    required this.repliedSenderName,
    required MessageStatus status,
    required String senderName,
    Key? key,
  }) : super(
          message: message,
          time: time,
          isSelected: isSelected,
          status: status,
          senderName: senderName,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return _RepliedImageReceivedMessageCardStateful(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      repliedContent: repliedContent,
      repliedSenderName: repliedSenderName,
      senderName: senderName,
    );
  }
}

class _RepliedImageReceivedMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String repliedContent;
  final String repliedSenderName;
  final String senderName;
  const _RepliedImageReceivedMessageCardStateful({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.repliedContent,
    required this.repliedSenderName,
    required this.senderName,
    Key? key,
  }) : super(key: key);

  @override
  State<_RepliedImageReceivedMessageCardStateful> createState() =>
      _RepliedImageReceivedMessageCardState();
}

class _RepliedImageReceivedMessageCardState
    extends State<_RepliedImageReceivedMessageCardStateful> {
  String? imageUrl = "";

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    String? url = await loadImageUrl(widget.blobName);
    if (mounted) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: imageUrl!.isEmpty
          ? const CircularProgressIndicator() // Show loading until image URL is fetched
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: widget.isSelected ? selectColor : Colors.transparent,
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Card(
                      color: firstNeutralColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                "${widget.senderName}:",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            // Display the image message
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImagePage(
                                      imageUrl: imageUrl!,
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                imageUrl!,
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
