import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/components/receive-message/received_message.dart';

class RepliedReceivedMessageCard extends ReceivedMessage {
  final String repliedContent;
  final String repliedSenderName;

  RepliedReceivedMessageCard({
    required String message,
    required DateTime time,
    required bool isSelected,
    required MessageStatus status,
    required this.repliedContent,
    required this.repliedSenderName,
    required String senderName,
    Key? key,
  }) : super(
          message: message,
          time: time,
          isSelected: isSelected,
          status: status,
          senderName: senderName,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: isSelected ? selectColor : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Card(
                color: firstNeutralColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display reply bubble
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xffb39ddb),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repliedSenderName ?? "Unknown",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              repliedContent,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "$senderName:",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      Text(
                        message,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatTime(time),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
