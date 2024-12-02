import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/components/stories-widget.dart';
import 'package:whisper/components/users-stories.dart';
import 'package:whisper/cubit/stories-cubit.dart';
import 'package:whisper/cubit/stories-state.dart';
import 'package:whisper/services/user-stories-service.dart';

class UserStoriesScreen extends StatelessWidget {
  final int userId;
  final String profilePic;
  final String userName;
  final bool isMyStory;

  const UserStoriesScreen(
      {Key? key,
      required this.userId,
      required this.profilePic,
      required this.userName,
      this.isMyStory = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserStoryCubit(UserStoriesService())..fetchUserStories(userId),
      child: Scaffold(
        body: BlocBuilder<UserStoryCubit, UserStoryState>(
          builder: (context, state) {
            if (state is UserStoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserStoryStoriesLoaded) {
              // Create the user object here
              List<User> users = [
                User(
                  id: userId,
                  profilePic: profilePic,
                  userName: userName,
                  stories:
                      state.stories, // Assign the stories to the User model
                )
              ];

              // Pass the user object to StoryViewer
              return StoryPage(
                  userIndex: 0, sampleUsers: users, isMyStory: isMyStory);
            } else if (state is UserStoryError) {
              print(state.message);
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No stories available.'));
            }
          },
        ),
      ),
    );
  }
}
