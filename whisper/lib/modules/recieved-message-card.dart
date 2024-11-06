import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whisper/models/chat-messages';

class ReceivedMessageCard extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isSelected;
  final ParentMessage? repliedMessage;

  const ReceivedMessageCard({
    super.key,
    required this.message,
    required this.time,
    this.isSelected = false,
    this.repliedMessage,
  });

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: isSelected
            ? const Color.fromARGB(255, 129, 142, 221)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (repliedMessage != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Card(
                      color: const Color(
                          0xff0A122F), // Dark blue for received message bubble
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Inner bubble with message content and sender's name
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                        255, 18, 37, 83), // Lighter purple
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
                                          color: Colors.white, // White text
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        repliedMessage!.content,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white), // White text
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Main received message content
                                Text(
                                  message,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 10,
                            child: Text(
                              _formatTime(time), // Format and display time
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Card(
                      color: const Color(
                          0xff0A122F), // Dark blue for received message bubble
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Main received message content
                                Text(
                                  message,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 10,
                            child: Text(
                              _formatTime(time), // Format and display time
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
