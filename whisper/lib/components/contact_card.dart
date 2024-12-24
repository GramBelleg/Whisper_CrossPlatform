import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';

// Utility function to format the last seen timestamp
String formatLastSeen(String? lastSeen) {
  if (lastSeen == null) return ''; // Return empty string if no lastSeen value

  DateTime messageTime =
      DateTime.parse(lastSeen).toLocal(); // Convert to local time
  Duration difference = DateTime.now().difference(messageTime);

  String formattedTime;
  if (difference.inDays == 0) {
    formattedTime = DateFormat.jm().format(messageTime); // e.g., 3:30 PM
  } else if (difference.inDays < 7) {
    formattedTime = DateFormat.E().format(messageTime); // e.g., Mon
  } else {
    formattedTime = DateFormat.Md().format(messageTime); // e.g., 10/9
  }

  return formattedTime;
}

class ContactCard extends StatelessWidget {
  final dynamic chat; // Accepts a single dynamic chat object

  const ContactCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    bool isOnline = chat['status'] == 'Online'; // Check if status is Online

    return Card(
      color: firstSecondaryColor, // Background color of the card
      child: ListTile(
        leading: chat['profilePicUrl'] != null
            ? ClipOval(
                child: Image.network(
                  chat['profilePicUrl'],
                  width: 40, // Set width of the circle
                  height: 40, // Set height of the circle
                  fit: BoxFit
                      .cover, // Make sure the image fits within the circle
                ),
              )
            : const ClipOval(
                child: Icon(
                  Icons.person,
                  size: 40, // Set the size of the icon
                ),
              ), // Default circular icon if no picture is available
        title: Text(
          chat['name'], // Display name
          style: TextStyle(color: secondNeutralColor),
        ),
        subtitle: Text(
          chat['status'], // Display status
          style: TextStyle(
            color: isOnline
                ? highlightColor
                : Colors.grey, // Highlight color for online/offline
          ),
        ),
        trailing: chat['lastSeen'] != null
            ? Text(
                'Last seen: ${formatLastSeen(chat['lastSeen'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor, // Last seen text color
                ),
              )
            : null,
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String senderProfilePic; // Primary URL for the sender's profile picture
  final String senderUserName; // Sender's username
  final String content; // Message content
  final String? media; // Media URL (optional)
  final String type; // Type of the message

  const MessageCard({
    Key? key,
    required this.senderProfilePic,
    required this.senderUserName,
    required this.content,
    this.media,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: firstSecondaryColor, // Background color of the card
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: NetworkImage(senderProfilePic),
          child: ClipOval(
            child: Image.network(
              senderProfilePic,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  "https://ui-avatars.com/api/?background=8d6aee&size=1500&color=fff&name=${formatName(senderUserName)}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_circle,
                    size: 32,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
        title: Text(
          senderUserName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: secondNeutralColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(color: secondNeutralColor),
            ), // Display message content
            if (media != null &&
                media!.isNotEmpty) // Display media if it exists
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Image.network(
                  media!,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://ui-avatars.com/api/?background=8d6aee&size=1500&color=fff&name=${formatName(senderUserName)}",
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            Text(
              type,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ), // Display message type
          ],
        ),
      ),
    );
  }
}
