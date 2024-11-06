import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart'; // Add this dependency to pubspec.yaml

class ReplyPreview extends StatelessWidget {
  final bool isReplying;
  final String senderName;
  final String content;
  final VoidCallback onCancelReply;

  const ReplyPreview({
    Key? key,
    required this.isReplying,
    required this.senderName,
    required this.content,
    required this.onCancelReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isReplying
        ? Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: firstNeutralColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.reply, // Reply icon from Font Awesome
                  color: Colors.blue[700],
                  size: 18.0,
                ),
                const SizedBox(width: 8.0), // Space between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reply to $senderName',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color: Colors.grey[600],
                      size: 22.0), // Increased size of "X" icon
                  onPressed: onCancelReply,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          )
        : Container();
  }
}
