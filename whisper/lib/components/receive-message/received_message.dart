import 'package:flutter/material.dart';
import 'package:whisper/components/own-message/own_message.dart';

abstract class ReceivedMessage extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isSelected;
  final MessageStatus status; // Added status property
  final String senderName;
  ReceivedMessage({
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    Key? key,
    required this.senderName,
  }) : super(key: key);

  String formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0
        ? 12
        : dateTime.hour % 12; // Handle 12 AM/PM correctly
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context);
}
