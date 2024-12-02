import 'package:whisper/models/story.dart';
import 'package:whisper/models/user.dart';

abstract class UserStoryState {}

class UserStoryInitial extends UserStoryState {}

class UserStoryLoading extends UserStoryState {}

class UserStoryLoaded extends UserStoryState {
  final List<User> users; // List of users that have stories

  UserStoryLoaded({required this.users});
}

class UserStoryStoriesLoaded extends UserStoryState {
  final List<Story> stories; // List of stories for the selected user

  UserStoryStoriesLoaded({required this.stories});
}

// class UserStoryStoriesViewsLoaded extends UserStoryState {
//   final List<UserView> userViews; // List of Views for the selected story

//   UserStoryStoriesViewsLoaded({required this.userViews});
// }

class UserStoryError extends UserStoryState {
  final String message;

  UserStoryError({required this.message});
}
