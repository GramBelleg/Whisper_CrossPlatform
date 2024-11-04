import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/visibility_cubit.dart';
import '../utils/visibility_utils.dart';

class VisibilitySettingsPage extends StatefulWidget {
  const VisibilitySettingsPage({super.key});

  @override
  State<VisibilitySettingsPage> createState() => _VisibilitySettingsPageState();
}

class _VisibilitySettingsPageState extends State<VisibilitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A122F),
      appBar: AppBar(
        title: Text(
          "Visibility Settings",
          style: TextStyle(color: Color(0xff8D6AEE)),
        ),
        backgroundColor: Color(0xFF0A122F),
        iconTheme: IconThemeData(color: Color(0xff8D6AEE)),
      ),
      body: BlocBuilder<VisibilityCubit, Map<String, dynamic>>(
        builder: (context, privacyState) {
          return ListView(
            children: [
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who can see my profile picture?",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      getVisibilityText(privacyState['profilePicture']),
                      style: TextStyle(
                          color: Color(0xff8D6AEE).withOpacity(0.6)),
                    )
                  ],
                ),
                onTap: () {
                  if (kDebugMode) print("profile picture visibility");
                  showVisibilityOptions(
                    context,
                    "Who can see my profile picture ?",
                    privacyState['profilePicture'],
                    (value) {
                      context
                          .read<VisibilityCubit>()
                          .updateProfilePictureVisibility(value);
                    },
                  );
                },
              ),
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who can see my stories?",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      getVisibilityText(privacyState['stories']),
                      style: TextStyle(
                          color: Color(0xff8D6AEE).withOpacity(0.6)),
                    )
                  ],
                ),
                onTap: () {
                  if (kDebugMode) print("stories visibility");
                  showVisibilityOptions(
                    context,
                    "Who can see my stories?",
                    privacyState['stories'],
                    (value) {
                      context
                          .read<VisibilityCubit>()
                          .updateStoriesVisibility(value);
                    },
                  );
                },
              ),
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who can see my last seen?",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      getVisibilityText(privacyState['lastSeen']),
                      style: TextStyle(
                          color: Color(0xff8D6AEE).withOpacity(0.6)),
                    )
                  ],
                ),
                onTap: () {
                  if (kDebugMode) print("last seen visibility");
                  showVisibilityOptions(context, "Who can see my last seen?",
                      privacyState['lastSeen'], (value) {
                    context
                        .read<VisibilityCubit>()
                        .updateLastSeenVisibility(value);
                  });
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Read Receipts",
                      style: TextStyle(color: Colors.white),
                    ),
                    Switch(
                      value: privacyState['readReceipts'],
                      onChanged: (bool value) {
                        if (kDebugMode) print("read receipts");
                        context
                            .read<VisibilityCubit>()
                            .updateReadReceipts(value);
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
