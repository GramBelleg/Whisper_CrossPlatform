import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/models/story.dart';
import 'package:whisper/cubit/user_story_state.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/models/user_view.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/user_stories_service.dart';
import 'package:whisper/socket.dart';

class UserStoryCubit extends Cubit<UserStoryState> {
  User? myUser;

  List<User> users = [];

  UserStoryCubit() : super(UserStoryInitial()) {
    //initUsers();
    print("call constructor UserStoryCubit");
  }

  // Load users from SharedPreferences
  Future<void> initUsers() async {
    print("initUsers");
    await retrieveUsersWithStories();
  }

  void setLikeUnLike(int userIndex, int storyIndex) {
    users[userIndex]
        .stories[storyIndex]
        .copyWith(liked: !users[userIndex].stories[storyIndex].liked);
    // print("other stories ${users.map((user) => user.toJson()).toList()}");

    emit(UserStoryLoaded(users: users, me: myUser));
  }

  // Fetch users with stories
  Future<void> retrieveUsersWithStories() async {
    try {
      emit(UserStoryLoading()); // Emit loading state

      final result = await fetchUsersWithStories();
      users = result.item1;
      myUser = result.item2;
      print("my stories  ${myUser!.toJson()}");

      emit(UserStoryLoaded(users: users, me: myUser));
    } catch (e) {
      emit(UserStoryError(message: 'Failed to load users with stories'));
    }
  }

  // Fetch stories for a specific user
  Future<void> retrieveUserStories(int userId) async {
    try {
      emit(UserStoryLoading()); // Emit loading state
      print("Fetching stories for user $userId...");

      final stories = await fetchUserStories(userId);

      users[userId].copyWith(stories: stories);

      emit(UserStoryLoaded(users: users, me: myUser));
    } catch (e) {
      emit(UserStoryError(message: 'Failed to load stories for the user'));
    }
  }

  /// Send a new story
  void sendStory(String content, String media, String type) {
    try {
      print("send story");
      SocketService.instance.socket
          ?.emit('story', {"content": content, "media": media, "type": type});
    } catch (e) {
      print("Error sending story: $e");
    }
  }

  /// Delete a story
  void deleteStory(int storyId) {
    try {
      SocketService.instance.socket?.emit('deleteStory', {"storyId": storyId});
    } catch (e) {
      print("Error deleting story: $e");
    }
  }

  /// View a story
  void sendViewStory(int storyId, String userName, String profilePic) {
    try {
      socket?.emit('viewStory', {
        "storyId": storyId,
        "userName": userName,
        "profilePic": profilePic,
      });
    } catch (e) {
      print("Error viewing story: $e");
    }
  }

  /// Like a story
  void sendLikeStory(
      int storyId, String userName, String profilePic, bool liked) {
    try {
      print("I like story ");
      socket?.emit('likeStory', {
        "storyId": storyId,
        "userName": userName,
        "profilePic": profilePic,
        "liked": liked,
      });
    } catch (e) {
      print("Error liking story: $e");
    }
  }

// Method to receive a new story
  Future<void> receiveStory(Map<String, dynamic> storyJson) async {
    emit(UserStoryLoading()); // Emit loading state

    int? myId = await getId();
    final userId = storyJson["userId"];
    String mediaUrl = await generatePresignedUrl(storyJson['media']);
    storyJson['media'] = mediaUrl;
    print("storyJson['media'] ${storyJson['media']}");
    if (myId == storyJson["userId"]) {
      final story = Story.fromJson(storyJson);
      if (myUser == null) {
        // Fetch user if myUser is null
        final user = await fetchUserById(userId); // to do api get user by id
        if (user != null) {
          user.stories.add(story);
        }
      } else {
        myUser!.stories.add(story); // Add story to myUser
      }
    } else {
      // Check if the user already exists in the users list
      final existingUser = users.firstWhere(
        (user) => user.id == userId,
      );

      if (existingUser.id == userId) {
        // If user exists, add the story to their stories list
        final story = Story.fromJson(storyJson);
        users[userId].stories.add(story);
      } else {
        // If user does not exist, create a new user by fetching them
        final user = await fetchUserById(userId);
        if (user != null) {
          final story = Story.fromJson(storyJson);
          user.stories.add(story); // Add story to the new user
          users.add(user); // Add user to the users list
// Save the new user data
        }
      }
    }
    emit(UserStoryLoaded(users: users, me: myUser));
  }

  // Method for viewing a story
  Future<void> receiveViewStory(Map<String, dynamic> data) async {
    emit(UserStoryLoading()); // Emit loading state

    final storyId = data['storyId'];

    if (myUser != null) {
      final userView = UserView(
        id: myUser!.id,
        userName: myUser!.userName,
        profilePic: myUser!.profilePic,
        liked: false, // Default to false until the user likes it
      );
      myUser!.stories[storyId].storyViews.add(userView);
      myUser!.stories[storyId]
          .copyWith(views: myUser!.stories[storyId].views + 1);

      emit(UserStoryLoaded(users: users, me: myUser));
    }
  }

// Method for liking a story
  Future<void> receiveLikeStory(Map<String, dynamic> data) async {
    emit(UserStoryLoading()); // Emit loading state

    final storyId = data['storyId'];

    if (myUser != null) {
      myUser!.stories[storyId].storyViews[storyId].copyWith(liked: true);

      // Update the likes count
      myUser!.stories[storyId]
          .copyWith(likes: myUser!.stories[storyId].likes + 1);

      // Emit the updated story to the server

      emit(UserStoryLoaded(users: users, me: myUser));
    }
  }

  // Method for deleting a story
  Future<void> receiveDeleteStory(Map<String, dynamic> data) async {
    emit(UserStoryLoading()); // Emit loading state

    int? myId = await getId();

    final storyId = data['storyId'];

    if (myId == data['userId']) {
      myUser!.stories.removeWhere((story) => story.id == storyId);

      emit(UserStoryLoaded(users: users, me: myUser));
    } else {
      users[storyId].stories.removeWhere((story) => story.id == storyId);
      emit(UserStoryLoaded(users: users, me: myUser));
    }
  }

  // Setup all socket listeners
  void setupSocketListeners() {
    // Listen for story updates via socket
    SocketService.instance.socket?.on('story', (data) {
      print("receive my story $data");
    });
    SocketService.instance.socket?.on('viewStory', (data) {
      receiveViewStory(data);
    });
    SocketService.instance.socket?.on('likeStory', (data) {
      receiveLikeStory(data);
    });
    SocketService.instance.socket?.on('deleteStory', (data) {
      receiveDeleteStory(data);
    });
  }
}
