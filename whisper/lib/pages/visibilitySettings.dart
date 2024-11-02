import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/visibility_cubit.dart';

class VisibilitySettingsPage extends StatefulWidget {
  const VisibilitySettingsPage({super.key});

  @override
  State<VisibilitySettingsPage> createState() => _VisibilitySettingsPageState();
}

class _VisibilitySettingsPageState extends State<VisibilitySettingsPage> {
  void _showVisibilityOptions(
    BuildContext context,
    String title,
    VisibilityState currentValue,
    Function(VisibilityState) onChanged,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0xFF0A122F),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    title,
                    style: TextStyle(color: Color(0xff8D6AEE)),
                  ),
                ),
                RadioListTile<VisibilityState>(
                  title: Text("Everyone",
                      style: TextStyle(color: Color(0xff8D6AEE))),
                  value: VisibilityState.everyone,
                  groupValue: currentValue,
                  onChanged: (VisibilityState? value) {
                    onChanged(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<VisibilityState>(
                  title: Text("My Contacts",
                      style: TextStyle(color: Color(0xff8D6AEE))),
                  value: VisibilityState.contacts,
                  groupValue: currentValue,
                  onChanged: (VisibilityState? value) {
                    onChanged(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<VisibilityState>(
                  title: Text("Nobody",
                      style: TextStyle(color: Color(0xff8D6AEE))),
                  value: VisibilityState.nobody,
                  groupValue: currentValue,
                  onChanged: (VisibilityState? value) {
                    onChanged(value!);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  String _getVisibilityText(VisibilityState state) {
    switch (state) {
      case VisibilityState.everyone:
        return "Everyone";
      case VisibilityState.contacts:
        return "My Contacts";
      case VisibilityState.nobody:
        return "Nobody";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VisibilityCubit(),
      child: Scaffold(
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
                        _getVisibilityText(privacyState['profilePicture']),
                        style: TextStyle(
                            color: Color(0xff8D6AEE).withOpacity(0.6)),
                      )
                    ],
                  ),
                  onTap: () {
                    if (kDebugMode) print("profile picture visibility");
                    _showVisibilityOptions(
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
                        _getVisibilityText(privacyState['stories']),
                        style: TextStyle(
                            color: Color(0xff8D6AEE).withOpacity(0.6)),
                      )
                    ],
                  ),
                  onTap: () {
                    if (kDebugMode) print("stories visibility");
                    _showVisibilityOptions(
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
                        _getVisibilityText(privacyState['lastSeen']),
                        style: TextStyle(
                            color: Color(0xff8D6AEE).withOpacity(0.6)),
                      )
                    ],
                  ),
                  onTap: () {
                    if (kDebugMode) print("last seen visibility");
                    _showVisibilityOptions(context, "Who can see my last seen?",
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
      ),
    );
  }
}
