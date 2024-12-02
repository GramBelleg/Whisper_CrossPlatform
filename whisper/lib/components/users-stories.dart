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

class Story {
  final int id;
  final String content;
  final String media;
  final String type; // Media type: image/video
  final int likes;
  final int views;
  final DateTime date;
  final bool isArchived;
  final String privacy;

  // Optional fields for viewed and liked (default to `false` if missing in JSON)
  final bool viewed;
  final bool liked;

  Story({
    required this.id,
    required this.content,
    required this.media,
    required this.type,
    required this.likes,
    required this.views,
    required this.date,
    required this.isArchived,
    required this.privacy,
    this.viewed = false,
    this.liked = false,
  });

  // Convert Story to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'media': media,
      'type': type,
      'likes': likes,
      'views': views,
      'date': date.toIso8601String(),
      'isArchived': isArchived,
      'privacy': privacy,
      'viewed': viewed,
      'liked': liked,
    };
  }

  // Create Story from JSON
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      content: json['content'] ?? '',
      media: json['media'] ?? '',
      type: json['type'] ?? 'UNKNOWN',
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
      date: DateTime.tryParse(json['date']) ??
          DateTime.now(), // Default to current date if parsing fails
      isArchived: json['isArchived'] ?? false,
      privacy: json['privacy'] ?? 'Everyone',
      viewed: json['viewed'] ?? false,
      liked: json['liked'] ?? false,
    );
  }

  // Create a copy of the Story with updated fields
  Story copyWith({
    int? id,
    String? content,
    String? media,
    String? type,
    int? likes,
    int? views,
    DateTime? date,
    bool? isArchived,
    String? privacy,
    bool? viewed,
    bool? liked,
  }) {
    return Story(
      id: id ?? this.id,
      content: content ?? this.content,
      media: media ?? this.media,
      type: type ?? this.type,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      date: date ?? this.date,
      isArchived: isArchived ?? this.isArchived,
      privacy: privacy ?? this.privacy,
      viewed: viewed ?? this.viewed,
      liked: liked ?? this.liked,
    );
  }
}
