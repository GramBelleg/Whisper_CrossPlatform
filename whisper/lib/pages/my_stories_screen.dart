import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/pages/story_page.dart';
import 'package:whisper/cubit/user_story_cubit.dart';
import 'package:whisper/cubit/user_story_state.dart';

class ShowMyStories extends StatelessWidget {
  const ShowMyStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserStoryCubit, UserStoryState>(
        builder: (context, state) {
          if (state is UserStoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserStoryLoaded) {
            final myUser = state.me;
            return StoryPage(
              users: [myUser!],
              userIndex: 0,
              isMyStory: true,
            );
          } else if (state is UserStoryError) {
            print(state.message);
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No stories available.'));
          }
        },
      ),
    );
  }
}
