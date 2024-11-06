import 'package:flutter/material.dart';
import '../keys/visibility_settings_keys.dart';
import '../constants/colors.dart';

enum VisibilityState { everyone, contacts, nobody }

void showVisibilityOptions(
  BuildContext context,
  String title,
  VisibilityState currentValue,
  Function(VisibilityState) onChanged,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          color: firstNeutralColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(color:secondNeutralColor),
                ),
              ),
              RadioListTile<VisibilityState>(
                key: VisibilitySettingsKeys.everyoneRadio,
                title: Text("Everyone",
                    style: TextStyle(color: primaryColor)),
                value: VisibilityState.everyone,
                groupValue: currentValue,
                onChanged: (VisibilityState? value) {
                  onChanged(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<VisibilityState>(
                key: VisibilitySettingsKeys.contactsRadio,
                title: Text("My Contacts",
                    style: TextStyle(color: primaryColor)),
                value: VisibilityState.contacts,
                groupValue: currentValue,
                onChanged: (VisibilityState? value) {
                  onChanged(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<VisibilityState>(
                key: VisibilitySettingsKeys.nobodyRadio,
                title:
                    Text("Nobody", style: TextStyle(color: primaryColor)),
                value: VisibilityState.nobody,
                groupValue: currentValue,
                onChanged: (VisibilityState? value) {
                  onChanged(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

String getVisibilityText(VisibilityState state) {
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
