import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Define the enum for message status
enum MessageStatus {
  sent,
  received,
  seen,
}

class OwnMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageStatus status; // Use the enum for status
  bool isSelected;

  OwnMessageCard({
    super.key,
    required this.message,
    required this.time,
    required this.isSelected,
    this.status = MessageStatus.sent, // Default to sent
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        // The container that spans the whole width of the screen
        width: MediaQuery.of(context).size.width,
        color: isSelected
            ? const Color.fromARGB(255, 129, 142, 221)
            : Colors.transparent, // Background color for selection
        padding: const EdgeInsets.symmetric(
            vertical: 5), // Optional vertical padding
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align message to the right
          children: [
            ConstrainedBox(
              // Constrain the width of the message container
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.8, // Max width for the message container (80% of the screen)
              ),
              child: Card(
                color: const Color(0xff8D6AEE), // Your desired color
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 10,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(width: 4),
                          // Display the appropriate icon based on the status
                          Icon(
                            status == MessageStatus.seen
                                ? FontAwesomeIcons.checkDouble
                                : status == MessageStatus.received
                                    ? FontAwesomeIcons
                                        .checkDouble // Double check for received
                                    : FontAwesomeIcons
                                        .check, // Single check for sent
                            color: status ==
                                    MessageStatus.seen // Blue color for seen
                                ? Colors.blue
                                : Colors
                                    .white, // Default color for other statuses
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
      ),
    );
  }
}
