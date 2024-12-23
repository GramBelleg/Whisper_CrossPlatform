import 'package:whisper/components/helpers.dart';
import 'package:whisper/models/story.dart';

class User {
  final int id;
  final String userName;
  final String profilePic;
  final List<Story> stories;

  User({
    required this.id,
    required this.userName,
    required this.profilePic,
    List<Story>? stories, // Allow null here
  }) : stories = stories ?? []; // Initialize with an empty mutable list

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
      stories: stories ?? this.stories,
    );
  }

  bool isValidUrl(String? profilePic) {
    if (profilePic == null || profilePic.isEmpty) return false;

    try {
      final uri = Uri.parse(profilePic);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      profilePic: json['profilePic'] ??
          "https://ui-avatars.com/api/?background=0a122f&size=128&color=fff&name=${formatName(json['userName'])}",
      stories: json['stories'] != null
          ? (json['stories'] as List)
              .map((storyJson) => Story.fromJson(storyJson))
              .toList()
          : [], // Use a mutable empty list here
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'profilePic': profilePic,
      'stories': stories.map((story) => story.toJson()).toList(),
    };
  }

  bool areAllStoriesViewed() {
    return stories.isNotEmpty && stories.every((story) => story.viewed);
  }
}
