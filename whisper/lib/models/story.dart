import 'package:whisper/models/user_view.dart';

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
  final List<UserView> storyViews;
  final bool viewed;
  final bool liked;

  Story({
    required this.id,
    required this.content,
    required this.media,
    required this.type,
    this.likes = 0,
    this.views = 0,
    required this.date,
    this.isArchived = false,
    this.privacy = "Everyone",
    this.storyViews = const [], // Default empty list
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
      'storyViews': storyViews
          .map((view) => view.toJson())
          .toList(), // Serialize storyViews
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
      storyViews: json['storyViews'] != null
          ? (json['storyViews'] as List)
              .map((viewJson) => UserView.fromJson(viewJson))
              .toList()
          : const [], // Deserialize storyViews
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
    List<UserView>? storyViews,
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
      storyViews: storyViews ?? this.storyViews,
      viewed: viewed ?? this.viewed,
      liked: liked ?? this.liked,
    );
  }
}
