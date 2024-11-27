// import 'package:flutter/material.dart';
// import 'package:swipe_to/swipe_to.dart';
// import 'package:whisper/models/chat-messages.dart';
// import 'package:whisper/modules/own-message/file-message-card.dart';
// import 'package:whisper/modules/own-message/forwarded-message-card.dart';
// import 'package:whisper/modules/own-message/normal-message-card.dart';
// import 'package:whisper/modules/own-message/own-message.dart';
// import 'package:whisper/modules/own-message/replied-message-card.dart';

// class CustomMessagesListView extends StatelessWidget {
//   final List<ChatMessage> messages;
//   final ScrollController scrollController;
//   final double paddingSpaceForReplay;
//   final Function(int messageIndex) onRightSwipe;
//   final Function(int messageId) onMessageLongPress;
//   final Function(int messageId) onMessageTap;
//   final int senderId;
//   final List<int> isSelectedList;

//   const CustomMessagesListView({
//     Key? key,
//     required this.messages,
//     required this.scrollController,
//     required this.paddingSpaceForReplay,
//     required this.onRightSwipe,
//     required this.onMessageLongPress,
//     required this.onMessageTap,
//     required this.senderId,
//     required this.isSelectedList,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height - 400,
//       child: Padding(
//         padding: EdgeInsets.only(bottom: paddingSpaceForReplay),
//         child: ListView.builder(
//           controller: scrollController,
//           itemCount: messages.length,
//           itemBuilder: (context, index) {
//             final messageData = messages[index];
//             return SwipeTo(
//               key: ValueKey(messageData.id),
//               iconColor: const Color(0xff8D6AEE),
//               onRightSwipe: (_) => onRightSwipe(index),
//               child: GestureDetector(
//                 onLongPress: () => onMessageLongPress(messageData.id!),
//                 onTap: () => onMessageTap(messageData.id!),
//                 child: _buildMessageCard(messageData),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageCard(ChatMessage messageData) {
//     if (messageData.sender!.id! == senderId) {
//       // Sent Messages
//       if (messageData.forwarded == true) {
//         return ForwardedMessageCard(
//           message: messageData.content,
//           time: messageData.time!,
//           status: MessageStatus.sent,
//           isSelected: isSelectedList.contains(messageData.id!),
//           messageSenderName: messageData.forwardedFrom!.userName,
//         );
//       } else if (messageData.parentMessage != null) {
//         return RepliedMessageCard(
//           message: messageData.content,
//           time: messageData.time!,
//           status: MessageStatus.sent,
//           isSelected: isSelectedList.contains(messageData.id!),
//           repliedContent: messageData.parentMessage!.content,
//           repliedSenderName: messageData.parentMessage!.senderName,
//         );
//       } else if (messageData.media != null && messageData.media!.isNotEmpty) {
//         return FileMessageCard(
//           message: messageData.content,
//           time: messageData.time!,
//           status: MessageStatus.sent,
//           isSelected: isSelectedList.contains(messageData.id!),
//           blobName: messageData.media!,
//         );
//       } else {
//         return NormalMessageCard(
//           message: messageData.content,
//           time: messageData.time!,
//           status: MessageStatus.sent,
//           isSelected: isSelectedList.contains(messageData.id!),
//         );
//       }
//     } else {
//       // Received Messages
//       if (messageData.forwarded == true) {
//         return ForwardedMessageCard(
//           message: messageData.content,
//           time: messageData.time!,
//           status: MessageStatus.sent,
//           isSelected: isSelectedList.contains(messageData.id!),
//           messageSenderName: messageData.forwardedFrom!.userName,
//         );
//       } else if (messageData.parentMessage != null) {
//         return RepliedMessageCard(
//           message: messageData.content,
//           time: messageData.time!,
//           status: MessageStatus.sent,
//           isSelected: isSelectedList.contains(messageData.id!),
//           repliedContent: messageData.parentMessage!.content,
//           repliedSenderName: messageData.parentMessage!.senderName,
//         );
//       } else {
//         return NormalMessageCard(
//           message: messageData.content,
//           time: messageData.time!,
//           status: MessageStatus.sent,
//           isSelected: isSelectedList.contains(messageData.id!),
//         );
//       }
//     }
//   }
// }
