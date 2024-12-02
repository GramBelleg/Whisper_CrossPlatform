import 'package:flutter/material.dart';
import 'package:story/story_image.dart';
import 'package:story/story_page_view.dart';
import 'package:video_player/video_player.dart'; // Import video player package
import 'package:whisper/components/helpers.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/socket.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({
    Key? key,
    required this.userIndex,
    required this.isMyStory,
    required this.sampleUsers,
    this.withCloseIcon = true,
  }) : super(key: key);

  final int userIndex;
  final List<User> sampleUsers;
  final bool withCloseIcon;
  final bool isMyStory;

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  VideoPlayerController? _videoPlayerController; // Nullable Video controller

  @override
  void initState() {
    super.initState();

    // Check if the user has stories
    if (widget.sampleUsers[widget.userIndex].stories.isNotEmpty) {
      final firstStory = widget.sampleUsers[widget.userIndex].stories[0];

      // Check if the first story is a video
      if (firstStory.type == "VIDEO") {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(firstStory.media),
        )..initialize().then((_) {
            setState(() {}); // Rebuild after initialization
          });
      }
    }
  }

  @override
  void dispose() {
    // Dispose the video controller to free up resources
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if there are no users or stories
    if (widget.sampleUsers.isEmpty ||
        widget.sampleUsers[widget.userIndex].stories.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "No stories available",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          int currentUserIndex = widget.userIndex + pageIndex;

          // Ensure the current user index is within bounds
          if (currentUserIndex >= widget.sampleUsers.length) {
            return Container(); // End the page list if user index exceeds length
          }

          final user = widget.sampleUsers[currentUserIndex];
          if (storyIndex >= 0 && storyIndex < user.stories.length) {
            final story = user.stories[storyIndex];

            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // Check if the story is a video or an image
                          if (story.type == "VIDEO")
                            // Video Story
                            Positioned.fill(
                              child: VideoPlayer(
                                _videoPlayerController!,
                              ),
                            )
                          else if (story.type == "IMAGE")
                            // Image Story
                            Positioned.fill(
                              child: StoryImage(
                                key: ValueKey(story.media),
                                imageProvider: NetworkImage(
                                  story.media,
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          else
                            // Fallback for unsupported media types
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  'Unsupported media format',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          // Centered Content
                          Positioned(
                            bottom: 100,
                            left: 16,
                            right: 16,
                            child: Text(
                              story.content,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Header with User Info
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 8),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user.profilePic == ''
                                ? 'https://ui-avatars.com/api/?background=8D6AEE&size=128&color=fff&name=${formatName(user.userName)}' // Default avatar URL
                                : user.profilePic),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container(); // Handle error when storyIndex is out of bounds
          }
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          int currentUserIndex = widget.userIndex + pageIndex;

          // Ensure the current user index is within bounds
          if (currentUserIndex >= widget.sampleUsers.length) {
            return Container(); // Return an empty container if out of bounds
          }

          final user = widget.sampleUsers[currentUserIndex];
          if (storyIndex >= 0 && storyIndex < user.stories.length) {
            final story = user.stories[storyIndex];

            return Stack(
              children: [
                if (widget.withCloseIcon)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: IconButton(
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
                  left: 16,
                  right: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        if (widget.isMyStory) ...[
                          Icon(
                            Icons.favorite,
                            color:
                                story.likes > 0 ? Colors.red : Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${story.likes}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.visibility,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${story.views} views',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.sampleUsers[widget.userIndex].stories
                                    .removeAt(storyIndex);
                                Navigator.pop(context);
                              });
                              SocketService.instance.deleteStory(story.id);
                            },
                          ),
                        ] else ...[
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: story.liked ? Colors.red : Colors.grey,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                // Handle like functionality
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
        initialStoryIndex: (pageIndex) => 0,
        pageLength: widget.sampleUsers.length - widget.userIndex,
        storyLength: (int pageIndex) {
          int currentUserIndex = widget.userIndex + pageIndex;
          if (currentUserIndex < widget.sampleUsers.length) {
            return widget.sampleUsers[currentUserIndex].stories.length;
          }
          return 0;
        },
        onPageLimitReached: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
