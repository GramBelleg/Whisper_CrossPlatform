import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/colors.dart';
import '../cubit/visibility_cubit.dart';
import '../utils/visibility_utils.dart';
import '../keys/visibility_settings_keys.dart';

class VisibilitySettingsPage extends StatefulWidget {
  const VisibilitySettingsPage({super.key});

  @override
  State<VisibilitySettingsPage> createState() => _VisibilitySettingsPageState();
}

class _VisibilitySettingsPageState extends State<VisibilitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      appBar: AppBar(
        title: Text(
          "Visibility Settings",
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: firstNeutralColor,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: BlocBuilder<VisibilityCubit, Map<String, dynamic>>(
        builder: (context, privacyState) {
          return ListView(
            children: [
              ListTile(
                key: VisibilitySettingsKeys.profilePictureTile,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who can see my profile picture?",
                      style: TextStyle(color: secondNeutralColor),
                    ),
                    Text(
                      privacyState['pfpPrivacy'],
                      style: TextStyle(color: primaryColor.withOpacity(0.6)),
                    )
                  ],
                ),
                onTap: () {
                  if (kDebugMode) print("profile picture visibility");
                  showVisibilityOptions(
                    context,
                    "Who can see my profile picture?",
                    privacyState['pfpPrivacy'],
                    (value) {
                      context
                          .read<VisibilityCubit>()
                          .updateProfilePictureVisibility(value);
                    },
                  );
                },
              ),
              ListTile(
                key: VisibilitySettingsKeys.storiesTile,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who can see my stories?",
                      style: TextStyle(color: secondNeutralColor),
                    ),
                    Text(
                      privacyState['storyPrivacy'],
                      style: TextStyle(color: primaryColor.withOpacity(0.6)),
                    )
                  ],
                ),
                onTap: () {
                  if (kDebugMode) print("stories visibility");
                  showVisibilityOptions(
                    context,
                    "Who can see my stories?",
                    privacyState['storyPrivacy'],
                    (value) {
                      context
                          .read<VisibilityCubit>()
                          .updateStoriesVisibility(value);
                    },
                  );
                },
              ),
              ListTile(
                key: VisibilitySettingsKeys.lastSeenTile,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who can see my last seen?",
                      style: TextStyle(color: secondNeutralColor),
                    ),
                    Text(
                      privacyState['lastSeenPrivacy'],
                      style: TextStyle(color: primaryColor.withOpacity(0.6)),
                    )
                  ],
                ),
                onTap: () {
                  if (kDebugMode) print("last seen visibility");
                  showVisibilityOptions(context, "Who can see my last seen?",
                      privacyState['lastSeenPrivacy'], (value) {
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
                      style: TextStyle(color: secondNeutralColor),
                    ),
                    Switch(
                      key: VisibilitySettingsKeys.readReceiptsSwitch,
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
