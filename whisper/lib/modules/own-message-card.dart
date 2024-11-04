import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:whisper/models/chat-messages';

enum MessageStatus {
  sent,
  received,
  seen,
}

class OwnMessageCard extends StatelessWidget {
  final String message;
  final DateTime time;
  final MessageStatus status;
  final bool isSelected;
  final ParentMessage? repliedMessage;

  OwnMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.isSelected,
    this.status = MessageStatus.sent,
    this.repliedMessage,
  }) : super(key: key);

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: isSelected
            ? const Color.fromARGB(255, 129, 142, 221)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (repliedMessage != null) ...[
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueAccent, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repliedMessage!.senderName ?? "Unknown",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      repliedMessage!.content,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: Card(
                    color: const Color(0xff8D6AEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 70,
                            top: 10,
                            bottom: 20,
                          ),
                          child: Text(
                            message,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 10,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(time),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white70),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                status == MessageStatus.seen
                                    ? FontAwesomeIcons.checkDouble
                                    : status == MessageStatus.received
                                        ? FontAwesomeIcons.checkDouble
                                        : FontAwesomeIcons.check,
                                color: status == MessageStatus.seen
                                    ? Colors.blue
                                    : Colors.white,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
