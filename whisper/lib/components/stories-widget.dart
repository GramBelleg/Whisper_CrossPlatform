import 'package:flutter/material.dart';
import 'package:story/story_page_view.dart';
import 'package:story/story_image.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/components/users-stories.dart';
import 'package:whisper/socket.dart';
import 'package:whisper/keys/story-keys.dart';

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
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume); // Assuming resume is a valid command
  }

  @override
  void dispose() {
    // Correcting the animation state to a valid constant
    indicatorAnimationController.value = IndicatorAnimationCommand.pause;
    indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.sampleUsers.isEmpty
          ? Center(child: Text("No users available"))
          : StoryPageView(
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
                                // Story Image
                                Positioned.fill(
                                  child: StoryImage(
                                    key: ValueKey(story.media),
                                    imageProvider: NetworkImage(
                                      story.media,
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                // Centered Content
                                Positioned(
                                  bottom:
                                      100, // Adjust this value for placement above the image
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
                  return Container(); // Handle the error when storyIndex is out of bounds
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
                              key: storyPageKeys.closeButton,
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
                                // Heart Icon and Count
                                Icon(
                                  Icons.favorite,
                                  color: story.likes > 0
                                      ? Colors.red
                                      : Colors.white70,
                                  size: 20,
                                ),
                                const SizedBox(
                                    width: 4), // Space between icon and number
                                Text(
                                  '${story.likes}', // Display the number of likes
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16), // Adjust spacing

                                // Views Icon and Count
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

                                const Spacer(), // Push delete icon to the other side

                                // Delete Icon
                                IconButton(
                                  key: storyPageKeys.deleteStoryButton,
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // Remove the story from the user's stories list
                                      widget
                                          .sampleUsers[widget.userIndex].stories
                                          .removeAt(storyIndex);
                                      Navigator.pop(context);
                                      storyIndex--;
                                    });

                                    // Call the delete story API
                                    SocketService.instance
                                        .deleteStory(story.id);

                                    // Check if there are no more stories left
                                    if (widget.sampleUsers[widget.userIndex]
                                        .stories.isEmpty) {
                                      // If no stories remain, navigate back
                                      Navigator.pop(context);
                                    }

                                    print("Story deleted");
                                  },
                                ),
                              ] else ...[
                                const Spacer(), // Push heart icon to the right

                                IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: story.liked
                                        ? Colors.red
                                        : Colors
                                            .grey, // Change color based on state
                                    size: 32, // Larger size for the icon
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // Handle like functionality
                                      // story.liked = !story.liked; // Toggle like state
                                    });

                                    if (story.liked) {
                                      print("Liked!");
                                    } else {
                                      print("Unliked!");
                                    }
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
                  return Container(); // Handle the error when storyIndex is out of bounds
                }
              },
              indicatorAnimationController: indicatorAnimationController,
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
