import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/blob_url_manager.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/pages/full_screen_image_page.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';

class ImageMessageCard extends OwnMessage {
  final String blobName;

  ImageMessageCard({
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
    return _ImageMessageCardStateful(
      blobName: blobName,
      caption: message,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
    );
  }
}

class _ImageMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String caption;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;

  const _ImageMessageCardStateful({
    required this.blobName,
    required this.caption,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  State<_ImageMessageCardStateful> createState() => _ImageMessageCardState();
}

class _ImageMessageCardState extends State<_ImageMessageCardStateful> {
  String? imageUrl = "";
  bool isConnected = true;
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

  // Future<void> loadImageUrl() async {
  //   String? savedImageUrl = await getImageUrl(widget.blobName);
  //   if (!mounted) return;
  //   if (savedImageUrl != null) {
  //     setState(() {
  //       imageUrl = savedImageUrl;
  //     });
  //   } else {
  //     await generateAndSaveImageUrl(widget.blobName);
  //   }
  // }

  // Future<void> generateAndSaveImageUrl(String blobName) async {
  //   try {
  //     String url = await generatePresignedUrl(blobName);
  //     if (!mounted) return;
  //     setState(() {
  //       imageUrl = url;
  //     });
  //     await saveImageUrl(blobName, url);
  //   } catch (e) {
  //     print('Error generating or saving image URL: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: imageUrl!.isEmpty
          ? const CircularProgressIndicator() // Show loading until image URL is fetched
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: widget.isSelected ? selectColor : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Card(
                      color: primaryColor,
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: firstSecondaryColor,
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                },
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
