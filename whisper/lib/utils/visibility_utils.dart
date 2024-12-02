import 'package:flutter/material.dart';
import '../keys/visibility_settings_keys.dart';
import '../constants/colors.dart';

void showVisibilityOptions(
  BuildContext context,
  String title,
  String currentValue,
  Function(String) onChanged,
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
                  style: TextStyle(color: secondNeutralColor),
                ),
              ),
              RadioListTile<String>(
                key: VisibilitySettingsKeys.everyoneRadio,
                title: Text("Everyone", style: TextStyle(color: primaryColor)),
                value: "Everyone",
                groupValue: currentValue,
                onChanged: (String? value) {
                  onChanged(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                key: VisibilitySettingsKeys.contactsRadio,
                title: Text("Contacts", style: TextStyle(color: primaryColor)),
                value: "Contacts",
                groupValue: currentValue,
                onChanged: (String? value) {
                  onChanged(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                key: VisibilitySettingsKeys.nobodyRadio,
                title: Text("Nobody", style: TextStyle(color: primaryColor)),
                value: "Nobody",
                groupValue: currentValue,
                onChanged: (String? value) {
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
