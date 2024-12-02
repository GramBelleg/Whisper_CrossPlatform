import 'package:whisper/models/story.dart';

class User {
  final int id;
  final String userName;
  final String profilePic;
  final List<Story> stories; // Changed to non-nullable, default to empty list

  User({
    required this.id,
    required this.userName,
    required this.profilePic,
    this.stories = const [], // Default to empty list if null
  });

  // Define the copyWith method to create a new instance with modified fields
  User copyWith({
    int? id,
    String? userName,
    String? profilePic,
    List<Story>? stories,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profilePic: profilePic ?? this.profilePic,
      stories: stories ?? this.stories, // Use existing stories if null
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      profilePic: json['profilePic'],
      stories: json['stories'] != null
          ? (json['stories'] as List)
              .map((storyJson) => Story.fromJson(storyJson))
              .toList()
          : const [], // Default to empty list if no stories
    );
  }
}
