import 'package:whisper/models/story.dart';
import 'package:whisper/models/user.dart';

abstract class UserStoryState {}

class UserStoryInitial extends UserStoryState {}

class UserStoryLoading extends UserStoryState {}

class UserStoryLoaded extends UserStoryState {
  final List<User> users;
  final User? me;
  UserStoryLoaded({required this.users, required this.me});
}

class UserStoryStoriesLoaded extends UserStoryState {
  final int userId; // User ID whose stories are loaded
  final List<Story> stories;

  UserStoryStoriesLoaded({required this.userId, required this.stories});
}

class UserStoryNewStoryReceived extends UserStoryState {
  final Story story;

  UserStoryNewStoryReceived({required this.story});
}

class UserStoryLikeUpdated extends UserStoryState {
  final int storyId;
  final bool liked;

  UserStoryLikeUpdated({required this.storyId, required this.liked});
}

class UserStoryViewed extends UserStoryState {
  final int storyId;

  UserStoryViewed({required this.storyId});
}

class UserStoryDeleted extends UserStoryState {
  final int storyId;

  UserStoryDeleted({required this.storyId});
}

class UserStoryError extends UserStoryState {
  final String message;

  UserStoryError({required this.message});
}
