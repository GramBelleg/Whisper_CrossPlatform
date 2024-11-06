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
                          padding: EdgeInsets.only(
                            left: 10,
                            right: repliedMessage != null ? 30 : 85,
                            top: repliedMessage != null ? 10 : 10,
                            bottom: repliedMessage != null ? 20 : 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display reply bubble if repliedMessage exists
                              if (repliedMessage != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0xffb39ddb), // lighter purple color for reply background
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              // Main message content
                              Text(
                                message,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        // Positioned time and status icons
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
