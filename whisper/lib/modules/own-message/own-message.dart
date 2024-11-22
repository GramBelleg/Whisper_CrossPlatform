import 'package:flutter/material.dart';

enum MessageStatus {
  sent,
  received,
  seen,
}

abstract class OwnMessage extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isSelected;
  final MessageStatus status; // Added status property

  OwnMessage({
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status, // Passed status into constructor
    Key? key,
  }) : super(key: key);

  String formatTime(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context);
}
