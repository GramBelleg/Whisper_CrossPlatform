import 'package:flutter/material.dart';
import 'package:whisper/modules/own-message/own-message.dart';

abstract class ReceivedMessage extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isSelected;
  final MessageStatus status; // Added status property

  ReceivedMessage({
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
