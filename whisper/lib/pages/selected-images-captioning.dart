import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:whisper/constants/colors.dart';

class SelectedImageCaptioning extends StatefulWidget {
  final List<String> mediaPaths; // List of image paths
  final Function sendFile;

  SelectedImageCaptioning({required this.mediaPaths, required this.sendFile});

  @override
  _SelectedImageCaptioningState createState() =>
      _SelectedImageCaptioningState();
}

class _SelectedImageCaptioningState extends State<SelectedImageCaptioning> {
  final TextEditingController _controller = TextEditingController();
  int currentIndex = 0;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  @override
  void dispose() {
    _disposeVideoPlayer();
    _controller.dispose();
    super.dispose();
  }

  void _initializeMedia() {
    if (_isVideo(widget.mediaPaths[currentIndex])) {
      _videoPlayerController?.dispose();
      _videoPlayerController =
          VideoPlayerController.file(File(widget.mediaPaths[currentIndex]))
            ..initialize().then((_) {
              setState(() {});
              _videoPlayerController?.play();
            });
    } else {
      _videoPlayerController?.pause();
    }
  }

  bool _isVideo(String path) {
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];
    final fileExtension = path.split('.').last.toLowerCase();
    return videoExtensions.contains(fileExtension);
  }

  void _disposeVideoPlayer() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.pause();
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add caption',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: firstNeutralColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: firstSecondaryColor,
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/chat-page-back-ground-image.svg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: _isVideo(widget.mediaPaths[currentIndex])
                        ? GestureDetector(
                            onTap: () {
                              if (_videoPlayerController!.value.isPlaying) {
                                _videoPlayerController!.pause();
                              } else {
                                _videoPlayerController!.play();
                              }
                            },
                            child: (_videoPlayerController != null &&
                                    _videoPlayerController!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _videoPlayerController!
                                        .value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController!),
                                  )
                                : CircularProgressIndicator()),
                          )
                        : Image.file(
                            File(widget.mediaPaths[currentIndex]),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentIndex > 0) // Show left arrow only if applicable
                      IconButton(
                        icon: Icon(Icons.arrow_left, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            currentIndex--;
                            _controller.clear();
                            _initializeMedia();
                          });
                        },
                      ),
                    Spacer(),
                    if (currentIndex < widget.mediaPaths.length - 1)
                      IconButton(
                        icon: Icon(Icons.arrow_right, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            currentIndex++;
                            _controller.clear();
                            _initializeMedia();
                          });
                        },
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: firstNeutralColor,
                            filled: true,
                            hintText: "Add caption here",
                            hintStyle: const TextStyle(color: Colors.white54),
                            contentPadding: const EdgeInsets.all(5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: firstNeutralColor,
                        child: IconButton(
                          onPressed: () {
                            for (String mediaPath in widget.mediaPaths) {
                              String mediaType =
                                  _isVideo(mediaPath) ? "VIDEO" : "IMAGE";
                              widget.sendFile(
                                  mediaPath, _controller.text, mediaType);
                            }
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.send,
                            color: primaryColor,
                          ),
                          iconSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
