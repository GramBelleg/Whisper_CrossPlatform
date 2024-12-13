import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/components/receive-message/received_message.dart';

class NormalReceivedMessageCard extends ReceivedMessage {
  NormalReceivedMessageCard({
    required String message,
    required DateTime time,
    required bool isSelected,
    required MessageStatus status,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "$senderName:",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
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
                            formatTime(time),
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
        ),
      ),
    );
  }
}
