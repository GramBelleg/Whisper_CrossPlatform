import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/own-message/own_message.dart';

class NormalMessageCard extends OwnMessage {
  NormalMessageCard({
    required String message,
    required DateTime time,
    required bool isSelected,
    required MessageStatus status,
    Key? key,
  }) : super(
          message: message,
          time: time,
          isSelected: isSelected,
          status: status,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: isSelected ? selectColor : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Card(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the main message
                      Text(
                        message,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      // Time and status row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Format the message time
                          Text(
                            formatTime(time),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(width: 4),
                          // Display message status icon
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
