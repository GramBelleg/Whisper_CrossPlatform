import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:whisper/modules/receive-message/received-message.dart';
import 'package:whisper/pages/full-screen-vedio-page.dart';
import 'package:whisper/services/read-file.dart';

class RepliedReceivedVideoMessageCard extends ReceivedMessage {
  final String blobName;
  final String repliedContent;
  final String repliedSenderName;

  RepliedReceivedVideoMessageCard({
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
          key: key,
          status: status,
        );

  @override
  Widget build(BuildContext context) {
    return _RepliedReceivedVideoMessageCardStateful(
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

class _RepliedReceivedVideoMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String repliedContent;
  final String repliedSenderName;

  const _RepliedReceivedVideoMessageCardStateful({
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
  State<_RepliedReceivedVideoMessageCardStateful> createState() =>
      _RepliedReceivedVideoMessageCardState();
}

class _RepliedReceivedVideoMessageCardState
    extends State<_RepliedReceivedVideoMessageCardStateful> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  String videoUrl = "";

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (mounted) {
      try {
        videoUrl = await generatePresignedUrl(widget.blobName);
        _videoController = VideoPlayerController.network(videoUrl)
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
      alignment: Alignment
          .centerLeft, // Align the message to the left for received messages
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: widget.isSelected ? selectColor : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Card(
                color:
                    const Color(0xff0A122F), // Dark color for received messages
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
                      // Display reply bubble
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(
                              0xffb39ddb), // Lighter color for replied message
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.repliedSenderName,
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
                      // Display video player
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenVideoPage(
                                videoUrl: videoUrl,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_isInitialized)
                              AspectRatio(
                                aspectRatio:
                                    _videoController?.value.aspectRatio ?? 1.0,
                                child: VideoPlayer(_videoController!),
                              )
                            else
                              const CircularProgressIndicator(),
                            const Icon(
                              Icons.play_circle_filled,
                              size: 64,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Message text
                      Text(
                        widget.message,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      // Time and message status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.time,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            widget.status == MessageStatus.seen
                                ? FontAwesomeIcons.checkDouble
                                : widget.status == MessageStatus.received
                                    ? FontAwesomeIcons.check
                                    : FontAwesomeIcons.clock,
                            color: widget.status == MessageStatus.seen
                                ? Colors.blue
                                : Colors.white,
                            size: 12,
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
