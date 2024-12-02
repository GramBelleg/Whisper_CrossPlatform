import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whisper/components/users-stories.dart';
import 'package:whisper/services/read-file.dart';

class StoryViewer extends StatefulWidget {
  final List<Story> stories;
  final String profilePic;

  const StoryViewer({Key? key, required this.stories, required this.profilePic})
      : super(key: key);

  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  int _currentStoryIndex = 0;
  late VideoPlayerController _videoPlayerController;
  late PageController _pageController;
  bool _isLoading = true;
  List<String> _mediaUrls = []; // Store media URLs here

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.stories.isNotEmpty) {
      // Initialize media URLs list with a default value (empty or null)
      _mediaUrls = List.generate(widget.stories.length, (index) => '');
      _loadMedia(widget.stories[_currentStoryIndex].media, _currentStoryIndex);
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _loadMedia(String media, int index) async {
    setState(() {
      _isLoading = true;
    });

    // Check if the media URL is already loaded for the current story
    if (_mediaUrls[index].isEmpty) {
      if (media.endsWith('.mp4')) {
        // For videos, generate the URL and initialize the video controller
        String mediaUrl = await generatePresignedUrl(media);
        setState(() {
          _mediaUrls[index] = mediaUrl; // Store the generated URL
        });
        _initializeVideo(mediaUrl);
      } else {
        setState(() {
          _isLoading = false;
          _mediaUrls[index] = media; // Directly use the image URL
        });
      }
    }
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _videoPlayerController.play();
      });
  }

  void _nextStory() {
    if (_currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _pageController.animateToPage(
        _currentStoryIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _loadMedia(widget.stories[_currentStoryIndex].media, _currentStoryIndex);
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _pageController.animateToPage(
        _currentStoryIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _loadMedia(widget.stories[_currentStoryIndex].media, _currentStoryIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _nextStory,
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) _previousStory();
          if (details.primaryDelta! < 0) _nextStory();
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final story = widget.stories[index];

                // Show loading indicator until media URL is ready
                if (_mediaUrls[index].isEmpty || _isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                // Display media once the URL is available
                return story.media.endsWith('.mp4')
                    ? VideoPlayer(_videoPlayerController)
                    : Image.network(
                        _mediaUrls[index], // Use the media URL stored
                        fit: BoxFit.cover,
                      );
              },
            ),
            Positioned(
              top: 40,
              left: 20,
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.profilePic), // Use profile picture
              ),
            ),
          ],
        ),
      ),
    );
  }
}
