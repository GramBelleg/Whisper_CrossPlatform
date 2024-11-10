import 'package:flutter/material.dart';
import 'package:whisper/components/story.dart';
import 'package:whisper/components/story-show.dart';

void main() {
  runApp(MaterialApp(
    home: StoryViewer(
      stories: [
        Story(
          mediaUrl: 'assets/images/el-gayar.jpg',
          userName: 'John Doe',
          userProfilePic: 'assets/images/el-gayar.jpg',
        ),
        Story(
          mediaUrl: 'assets/videos/story.mp4',
          isVideo: true,
          userName: 'Jane Doe',
          userProfilePic: 'assets/images/el-gayar.jpg',
        ),
        // Initial list of stories...
      ],
    ),
  ));
}
