import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/models/story.dart';
import 'package:whisper/cubit/user_story_state.dart'; // Your states for managing story loading
import 'package:whisper/services/user_stories_service.dart'; // Your API service
import 'package:whisper/socket.dart';

class UserStoryCubit extends Cubit<UserStoryState> {
  final UserStoriesService _userStoryService;
  final socket = SocketService.instance.socket;

  // Store stories locally

  Map<int, List<Story>> userStories = {};

  UserStoryCubit(this._userStoryService) : super(UserStoryInitial()) {
    // _setupSocketListeners();
  }

  // Fetch users with stories
  Future<void> fetchUsersWithStories() async {
    try {
      emit(UserStoryLoading()); // Emit loading state
      final users = await _userStoryService
          .fetchUsersWithStories(); // Fetch users from the API
      emit(UserStoryLoaded(
          users: users)); // Emit success state with fetched users
    } catch (e) {
      emit(UserStoryError(message: 'Failed to load users with stories'));
    }
  }

  // Fetch stories for a specific user
  Future<void> fetchUserStories(int userId) async {
    try {
      emit(UserStoryLoading()); // Emit loading state
      print("my stories wait");

      final stories = await _userStoryService
          .fetchUserStories(userId); // Fetch stories for the user

      // userStories[userId] = stories; // Update the local list of stories
      emit(UserStoryStoriesLoaded(
          stories: stories)); // Emit success state with fetched stories
    } catch (e) {
      emit(UserStoryError(message: 'Failed to load stories for the user'));
    }
  }

  // Future<void> fetchStoryViews(int userId) async {
  //   try {
  //     emit(UserStoryLoading()); // Emit loading state
  //     print("my stories wait");

  //     final userViews = await _userStoryService.fetchStoryViews(userId);

  //     emit(UserStoryStoriesViewsLoaded(userViews: userViews));
  //   } catch (e) {
  //     emit(UserStoryError(message: 'Failed to load Views for the story'));
  //   }
  // }

  // Setup WebSocket listeners
  // void _setupSocketListeners() {
  //   // Listen for the `getStory` message from the server
  //   socket?.on('story', (data) {
  //     // Assuming the incoming data follows this structure:
  //     // {
  //     //   "id": 1,
  //     //   "userId": 123,
  //     //   "content": "This is a story",
  //     //   "media": "media-url",
  //     //   "date": "2024-11-30T18:27:18.990Z"
  //     // }
  //     var dataStory = jsonDecode(data);

  //     // Parse incoming data to a Story object
  //     Story newStory = Story.fromJson(data);

  //     // Update the user's story list
  //     if (userStories.containsKey(dataStory["userId"])) {
  //       userStories[dataStory["userId"]]!.add(newStory);
  //     } else {
  //       userStories[dataStory["userId"]] = [newStory];
  //     }

  //     // Emit the updated state with the new story added
  //     emit(UserStoryStoriesLoaded(stories: userStories[dataStory["userId"]]!));
  //   });
  // }
}
