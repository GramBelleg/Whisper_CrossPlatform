import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Story {
  final String mediaUrl; // Media URL for image/video/text
  final bool isVideo; // Flag to check if it's a video
  final String userName; // User's name for the story
  final String userProfilePic; // User profile picture
  final String? text; // Text for text-based stories (nullable)

  Story({
    required this.mediaUrl,
    this.isVideo = false,
    required this.userName,
    required this.userProfilePic,
    this.text, // Can be null if it's not a text story
  });
}

class StoryViewer extends StatefulWidget {
  final List<Story> stories;

  StoryViewer({required this.stories});

  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  int _currentStoryIndex = 0;
  late VideoPlayerController _videoPlayerController;
  late PageController _pageController;
  bool _isLoading = true;
  Timer? _autoSwipeTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSwipeTimer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _autoSwipeTimer?.cancel();
    super.dispose();
  }

  // Start auto swipe timer
  void _startAutoSwipeTimer() {
    _autoSwipeTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentStoryIndex < widget.stories.length - 1) {
        _nextStory();
      } else {
        timer.cancel();
      }
    });
  }

  // Load the media (image/video)
  void _loadMedia(String url) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Simulate loading delay
    setState(() {
      _isLoading = false;
    });
  }

  // Initialize the video player if it's a video
  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _videoPlayerController.play();
      });
  }

  // Navigate to the next story
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
    }
  }

  // Navigate to the previous story
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
    }
  }

  // Dynamically add a story
  void _addStory(Story story) {
    setState(() {
      widget.stories.add(story); // Add new story to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Dynamically add a story (Example: Adding a text story)
              _addStory(Story(
                mediaUrl: 'https://example.com/image.jpg',
                userName: 'New User',
                userProfilePic: 'https://example.com/user.jpg',
                text: 'New Dynamic Story Text', // You can add a text here
              ));
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.stories.length,
        itemBuilder: (context, index) {
          Story story = widget.stories[index];

          // Load media (image/video) when a new story is displayed
          _loadMedia(story.mediaUrl);

          // Initialize video if it's a video story
          if (story.isVideo) {
            _initializeVideo(story.mediaUrl);
          }

          return GestureDetector(
            onTap: _nextStory,
            onHorizontalDragUpdate: (details) {
              if (details.primaryDelta! > 0) {
                _previousStory();
              } else if (details.primaryDelta! < 0) {
                _nextStory();
              }
            },
            child: Stack(
              children: [
                // Display image/video/text
                story.isVideo
                    ? _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : VideoPlayer(_videoPlayerController)
                    : story.text != null
                        ? _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    story.text!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                        : _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Image.network(
                                story.mediaUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                // Profile Picture and User Name
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(story.userProfilePic),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    story.userName,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
