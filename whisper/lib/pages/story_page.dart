import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whisper/components/list_views_story.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/story_page_keys.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/models/user_view.dart';
import 'package:whisper/socket.dart';

class StoryPage extends StatefulWidget {
  final List<User> users;
  final bool isMyStory;
  final int userIndex;

  const StoryPage({
    super.key,
    required this.users,
    required this.userIndex,
    this.isMyStory = false,
  });

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentUserIndex = 0;
  int currentStoryIndex = 0;
  late Timer _timer;
  double _progress = 0.0;
  VideoPlayerController? _videoController;
  final double _storyDuration = 30.0;

  @override
  void initState() {
    super.initState();
    currentUserIndex = widget.userIndex;
    currentStoryIndex = 0;
    _timer = Timer(Duration.zero, () {}); // Initialize the timer

    _startStoryTimer();
  }

  void _startStoryTimer() {
    if (_timer.isActive) _timer.cancel();
    final currentUser = widget.users[currentUserIndex];
    final currentStory = currentUser.stories[currentStoryIndex];
    double storyDuration;

    if (currentStory.type == 'video' && _videoController != null) {
      final videoDuration =
          _videoController!.value.duration.inSeconds.toDouble();
      storyDuration =
          videoDuration < _storyDuration ? videoDuration : _storyDuration;
    } else {
      storyDuration = _storyDuration;
    }

    // Ensure storyDuration is valid (greater than zero)
    if (storyDuration <= 0) {
      storyDuration = _storyDuration; // fallback to default duration
    }

    double progressIncrementPerSecond = 1.0 / storyDuration;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        if (_progress < 1.0) {
          _progress += progressIncrementPerSecond / 10;
        } else {
          _goToNextStory();
          _progress = 0.0;
        }
      });
    });
  }

  void _resetStory() {
    _progress = 0.0;
    _timer.cancel();
    _videoController?.dispose();
    _videoController = null;
    _startStoryTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  void _goToNextStory() {
    setState(() {
      if (currentStoryIndex <
          widget.users[currentUserIndex].stories.length - 1) {
        currentStoryIndex++;
      } else if (currentUserIndex < widget.users.length - 1) {
        currentUserIndex++;
        currentStoryIndex = 0;
      } else {
        Navigator.pop(context);
      }
      _resetStory();
    });
  }

  void _goToPreviousStory() {
    setState(() {
      if (currentStoryIndex > 0) {
        currentStoryIndex--;
      } else if (currentUserIndex > 0) {
        currentUserIndex--;
        currentStoryIndex = widget.users[currentUserIndex].stories.length - 1;
      }
      _resetStory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.users[currentUserIndex];
    final currentStory = currentUser.stories[currentStoryIndex];

    if (currentStory.type == 'video' && _videoController == null) {
      _videoController = VideoPlayerController.network(currentStory.media)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _videoController?.play();
              _startStoryTimer();
            });
          }
        });
    } else if (currentStory.type == 'IMAGE') {
      _startStoryTimer();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth =
              MediaQuery.of(context).size.width; // Get the screen width
          if (details.globalPosition.dx < screenWidth / 2) {
            _goToPreviousStory();
          } else {
            _goToNextStory();
          }
        },
        child: Stack(
          children: [
            Center(
              child: currentStory.type == 'IMAGE'
                  ? Image.network(
                      currentStory.media,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : (_videoController != null &&
                          _videoController!.value.isInitialized)
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      : const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              top: 25,
              left: 10,
              right: 10,
              child: Row(
                children: widget.users[currentUserIndex].stories.map((story) {
                  int index =
                      widget.users[currentUserIndex].stories.indexOf(story);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: LinearProgressIndicator(
                        value: index == currentStoryIndex
                            ? _progress
                            : (index < currentStoryIndex ? 1.0 : 0.0),
                        backgroundColor: Colors.white.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.profilePic),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currentUser.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: IconButton(
                      key: Key(storyPageKeys.closeButton),
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 5,
                  right: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        if (widget.isMyStory) ...[
                          IconButton(
                            key: Key(storyPageKeys.showViewsLikesButton),
                            onPressed: () {
                              _showUserViewModal(currentStory.storyViews);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: currentStory.likes > 0
                                  ? Colors.red
                                  : Colors.white70,
                            ),
                          ),
                          Text(
                            '${currentStory.likes}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            key: Key(storyPageKeys.showViewsViewsButton),
                            onPressed: () {
                              _showUserViewModal(currentStory.storyViews);
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '${currentStory.views}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                          IconButton(
                            key: Key(storyPageKeys.deleteStoryButton),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.users[widget.userIndex].stories
                                    .removeAt(currentStoryIndex);
                              });
                              SocketService.instance
                                  .deleteStory(currentStory.id);
                            },
                          ),
                        ] else ...[
                          const Spacer(),
                          IconButton(
                            key: Key(storyPageKeys.likeButton),
                            icon: Icon(
                              Icons.favorite,
                              color:
                                  currentStory.liked ? Colors.red : Colors.grey,
                              size: 32,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Text in the center-bottom of the screen
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Text(
                  currentStory.content, // Change this to the text you want
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Adjust font size as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserViewModal(List<UserView> userViews) {
    // Pause the video player
    _videoController?.pause();
    _timer.cancel();
    // Show the modal bottom sheet
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: primaryColor,
      builder: (context) {
        return UserViewListWithHeader(
          headerTitle: "Views",
          userViews: userViews,
        );
      },
    ).whenComplete(() {
      // Resume the video after modal is closed
      _videoController?.play(); // Restart the video if it's paused
      _startStoryTimer(); // Restart the timer to resume the story
    });
  }
}
