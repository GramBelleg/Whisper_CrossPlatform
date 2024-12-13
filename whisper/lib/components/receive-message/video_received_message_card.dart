import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/blob_url_manager.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/components/receive-message/received_message.dart';
import 'package:whisper/pages/full_screen_video_page.dart';
import 'package:whisper/services/read_file.dart';

class VideoReceivedMessageCard extends ReceivedMessage {
  final String blobName;

  VideoReceivedMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
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
    return _VideoReceivedMessageCardStateful(
      blobName: blobName,
      caption: message,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      senderName: senderName,
    );
  }
}

class _VideoReceivedMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String caption;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String senderName;
  const _VideoReceivedMessageCardStateful({
    required this.blobName,
    required this.caption,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.senderName,
    Key? key,
  }) : super(key: key);

  @override
  State<_VideoReceivedMessageCardStateful> createState() =>
      _VideoReceivedMessageCardState();
}

class _VideoReceivedMessageCardState
    extends State<_VideoReceivedMessageCardStateful> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  String? videoUrl = "";

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (mounted) {
      try {
        videoUrl = await loadImageUrl(widget.blobName);
        _videoController = VideoPlayerController.network(videoUrl!)
          ..setVolume(0) // Mute the audio
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
              });
            }
          }).catchError((error) {
            print("Error initializing video: $error");
            if (mounted) {
              setState(() {
                _isInitialized = false;
              });
            }
          });
      } catch (e) {
        print("Error fetching video URL: $e");
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          Alignment.centerLeft, // Align to the left for received messages
      child: !_isInitialized
          ? const CircularProgressIndicator() // Show loading until video is ready
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: widget.isSelected ? selectColor : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Card(
                      color: firstNeutralColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                "${widget.senderName}:",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenVideoPage(
                                      videoUrl: videoUrl!,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio:
                                        _videoController?.value.aspectRatio ??
                                            1.0,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                  const Icon(
                                    Icons.play_circle_filled,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                ],
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
