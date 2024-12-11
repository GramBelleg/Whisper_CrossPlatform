import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/full_screen_vedio_page_keys.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPage({required this.videoUrl});

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isError = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isError = false;
          });
          _controller.play();
          _isPlaying = true;
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isError = true;
          });
        }
        print('Error initializing video: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          key: Key(FullScreenVideoPageKeys.backButton),
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0, // Optional: removes shadow from AppBar
      ),
      body: Center(
        child: _isError
            ? Container(
                key: Key(FullScreenVideoPageKeys.errorContainer),
                color: firstSecondaryColor,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              )
            : _controller.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        key: Key(FullScreenVideoPageKeys.videoPlayerContainer),
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Icon(
                          key: Key(FullScreenVideoPageKeys.playPauseButton),
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(
                    key: Key(FullScreenVideoPageKeys.loadingIndicator),
                  ), // Show loading until video is initialized
      ),
    );
  }
}
