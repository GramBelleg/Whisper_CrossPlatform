import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whisper/models/chat-messages.dart';
import 'package:whisper/modules/own-message/file-message-card-forward.dart';
import 'package:whisper/modules/own-message/file-message-card-replied.dart';
import 'package:whisper/modules/own-message/file-message-card.dart';
import 'package:whisper/modules/own-message/forwarded-message-card.dart';
import 'package:whisper/modules/own-message/normal-message-card.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:whisper/modules/own-message/replied-message-card.dart';
import 'package:whisper/modules/receive-message/file-received-message-card.dart';
import 'package:whisper/modules/receive-message/forwarded-received-file-message-card.dart';
import 'package:whisper/modules/receive-message/forwarded-received-message-card.dart';
import 'package:whisper/modules/receive-message/normal-received-message-card.dart';
import 'package:whisper/modules/receive-message/replied-received-file-message.dart';
import 'package:whisper/modules/receive-message/replied-received-message-card.dart';

class MessageList extends StatelessWidget {
  final ScrollController scrollController;
  final List<ChatMessage> messages;
  final ValueChanged<ChatMessage> onLongPress;
  final ValueChanged<ChatMessage> onTap;
  final ValueChanged<ChatMessage> onRightSwipe;
  final List<int> isSelectedList;
  final int senderId;
  const MessageList({
    required this.scrollController,
    required this.messages,
    required this.onLongPress,
    required this.onTap,
    required this.isSelectedList,
    required this.senderId,
    required this.onRightSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final messageData = messages[index];
        return SwipeTo(
          key: ValueKey(messageData.id),
          iconColor: Color(0xff8D6AEE),
          onRightSwipe: (details) {
            onRightSwipe(messageData);
          },
          child: GestureDetector(
            onLongPress: () => onLongPress(messageData),
            onTap: () => onTap(messageData),
            child: messageData.sender!.id == senderId
                ? _buildSenderMessage(messageData)
                : _buildReceiverMessage(messageData),
          ),
        );
      },
    );
  }

  Widget _buildSenderMessage(ChatMessage messageData) {
    if (messageData.forwarded == true && messageData.media == null) {
      return ForwardedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty) {
      return ForwardedFileMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        forwardedSenderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.parentMessage != null && messageData.media == null) {
      print(
          "aaaaaa${messageData.content}, ${messageData.time!},${messageData.id != null && isSelectedList.contains(messageData.id!)},${messageData.parentMessage!.content},${messageData.parentMessage!.senderName}");
      return RepliedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty) {
      return RepliedFileMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
        status: MessageStatus.sent,
      );
    } else if (messageData.media != null && messageData.media!.isNotEmpty) {
      return FileMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else {
      return NormalMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
      );
    }
  }

  Widget _buildReceiverMessage(ChatMessage messageData) {
    if (messageData.forwarded == true && messageData.media == null) {
      return ForwardedReceivedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty) {
      return ForwardedFileReceivedMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.parentMessage != null && messageData.media == null) {
      return RepliedReceivedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty) {
      return FileRepliedReceivedMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
        status: MessageStatus.sent,
      );
    } else if (messageData.media != null && messageData.media!.isNotEmpty) {
      return FileReceivedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else {
      return NormalReceivedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected:
            messageData.id != null && isSelectedList.contains(messageData.id!),
      );
    }
  }
}
