import 'package:flutter/material.dart';

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
              title:
                  Text("Everyone", style: TextStyle(color: Color(0xff8D6AEE))),
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
              title: Text("Nobody", style: TextStyle(color: Color(0xff8D6AEE))),
              value: VisibilityState.nobody,
              groupValue: currentValue,
              onChanged: (VisibilityState? value) {
                onChanged(value!);
                Navigator.pop(context);
              },
            ),
          ],
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
