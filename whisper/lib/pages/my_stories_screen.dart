import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/constants/colors.dart';
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
            if (myUser!.stories.isNotEmpty) {
              return StoryPage(
                users: [myUser],
                userIndex: 0,
                isMyStory: true,
              );
            } else {
              return Scaffold(
                backgroundColor: primaryColor,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No stories available",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        key: const Key('popScreenButton'),
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: secondNeutralColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          backgroundColor: firstSecondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Go Back",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
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
