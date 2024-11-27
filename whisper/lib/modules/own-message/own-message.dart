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
  final MessageStatus status; 

  OwnMessage({
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status, 
    Key? key,
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
