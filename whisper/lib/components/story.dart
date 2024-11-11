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
