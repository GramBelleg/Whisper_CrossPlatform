import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class RecievedMessageCard extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isSelected;

  const RecievedMessageCard({
    super.key,
    required this.message,
    required this.time,
    this.isSelected = false,
  });

  // Function to format DateTime as "HH:mm"
  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime); // Format as hours:minutes
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Card(
                color: const Color(0xff0A122F),
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
                            _formatTime(time), // Format and display time
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(width: 4),
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
